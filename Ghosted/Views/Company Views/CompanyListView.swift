import SwiftUI

struct CompanyListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isOn = false
    @State private var audioManager = AVAudioPlayerManager()
    @State private var showAddCompanySheet = false
    @State private var showEditCompanySheet = false
    @State private var selectedCompany: Company? = nil
    @State private var showAddOrderSheet: Bool = false
    @State private var showAddContactSheet: Bool = false
    @State private var showAddInteractionSheet: Bool = false
    @State private var showAddTaskSheet: Bool = false
    @State var showAlert: Bool = false
    
    @State private var sectionExpandedStates: [Company.Status: Bool] = [
        .activeClient: true,
        .warmLead: true,
        .coldLead: true,
        .ghosting: true,
        .closedLost: true
    ]
    
    var body: some View {
        Group {
            if dataModel.companies.isEmpty {
                EmptyStateView(showAlert: $showAlert)
            } else {
                CompanyListContent(
                    sectionExpandedStates: $sectionExpandedStates,
                    selectedCompany: $selectedCompany,
                    showAddOrderSheet: $showAddOrderSheet,
                    showAddContactSheet: $showAddContactSheet,
                    showAddInteractionSheet: $showAddInteractionSheet,
                    showAddTaskSheet: $showAddTaskSheet,
                    showEditAccountSheet: $showEditCompanySheet,
                    deleteAccount: deleteAccount
                )
            }
        }
        .onChange(of: showEditCompanySheet) { oldValue, newValue in
            if !newValue {
                selectedCompany = nil
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedCompany = nil
                    showAddCompanySheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddCompanySheet) {
            AddCompanyView(isPresented: $showAddCompanySheet, companyToEdit: nil)
        }
        .sheet(isPresented: $showEditCompanySheet, onDismiss: {
            selectedCompany = nil
        }) {
            if let companyToEdit = selectedCompany {
                AddCompanyView(isPresented: $showEditCompanySheet, companyToEdit: companyToEdit)
            }
        }
        .sheet(isPresented: Binding(
            get: { showAddContactSheet && selectedCompany != nil },
            set: { newValue in showAddContactSheet = newValue }
        )) {
            if let company = selectedCompany {
                AddContactView(isPresented: $showAddContactSheet, company: company)
            }
        }
        .sheet(isPresented: Binding(
            get: { showAddInteractionSheet && selectedCompany != nil },
            set: { newValue in showAddInteractionSheet = newValue }
        )) {
            if let company = selectedCompany {
                AddInteractionView(company: company)
            }
        }
        .sheet(isPresented: Binding(
            get: { showAddOrderSheet && selectedCompany != nil },
            set: { newValue in showAddOrderSheet = newValue }
        )) {
            if let company = selectedCompany {
                AddOrderView(company: company)
            }
        }
        .sheet(isPresented: Binding(
            get: { showAddTaskSheet && selectedCompany != nil },
            set: { newValue in showAddTaskSheet = newValue }
        )) {
            if let company = selectedCompany {
                AddTaskView(company: company)
            }
        }
    }
    
    private func deleteAccount(at offsets: IndexSet, for status: Company.Status) {
        let companiesToDelete = offsets.map { sortedCompanies(status: status)[$0] }
        for company in companiesToDelete {
            dataModel.deleteCompany(company)
        }
    }
    
    private func sortedCompanies(status: Company.Status) -> [Company] {
        return dataModel.companies
            .filter { $0.status == status }
            .sorted { $0.name < $1.name }
    }
}

struct CompanyListContent: View {
    @EnvironmentObject var dataModel: DataModel
    @Binding var sectionExpandedStates: [Company.Status: Bool]
    @Binding var selectedCompany: Company?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool
    var deleteAccount: (IndexSet, Company.Status) -> Void
    
    var body: some View {
        List {
            ForEach(Company.Status.allCases, id: \.self) { status in
                let companiesForStatus = sortedCompanies(status: status)
                CompanySectionView(
                    status: status,
                    companies: companiesForStatus,
                    companyCount: companiesForStatus.count,
                    isExpanded: sectionExpandedStates[status] ?? false,
                    toggleExpansion: {
                        withAnimation {
                            sectionExpandedStates[status]?.toggle()
                        }
                    },
                    deleteAction: { indexSet in
                        deleteAccount(indexSet, status)
                    },
                    selectedCompany: $selectedCompany,
                    showAddOrderSheet: $showAddOrderSheet,
                    showAddContactSheet: $showAddContactSheet,
                    showAddInteractionSheet: $showAddInteractionSheet,
                    showAddTaskSheet: $showAddTaskSheet,
                    showEditAccountSheet: $showEditAccountSheet
                )
            }
        }
    }
    
    private func sortedCompanies(status: Company.Status) -> [Company] {
        return dataModel.companies
            .filter { $0.status == status }
            .sorted { $0.name < $1.name }
    }
}

struct CompanySectionView: View {
    @EnvironmentObject var dataModel: DataModel
    var status: Company.Status
    var companies: [Company]
    var companyCount: Int
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    var deleteAction: (IndexSet) -> Void
    
    @Binding var selectedCompany: Company?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool
    
    var body: some View {
        if !companies.isEmpty {
            Section {
                if isExpanded {
                    ForEach(companies.sorted(by: { $0.country.countryCode < $1.country.countryCode })) { company in
                        NavigationLink(destination: CompaniesHomeView(selectedTab: selectedTab(for: company), company: company)) {
                            CompanyRow(company: company, selectedCompany: $selectedCompany, showAddOrderSheet: $showAddOrderSheet, showAddContactSheet: $showAddContactSheet, showAddInteractionSheet: $showAddInteractionSheet, showAddTaskSheet: $showAddTaskSheet, showEditAccountSheet: $showEditAccountSheet)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = companies.firstIndex(where: { $0.id == company.id }) {
                                    deleteAction(IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            } header: {
                Button(action: toggleExpansion) {
                    HStack {
                        Text("\(statusDisplayName)")
                        Text("\(companyCount)")
                            .font(.caption)
                            .frame(width: 18, height: 18)
                            .background(Circle().fill(companyCount == 0 ? Color.secondary : Color.accentColor).opacity(0.3))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                            .padding(.trailing, 8)
                    }
                    .contentShape(Rectangle()) // Makes the whole header tappable
                    .padding(.vertical, 5)
                    .background(Color(UIColor.systemGroupedBackground)) // Optional background for better visibility
                }
                .buttonStyle(PlainButtonStyle()) // Removes the button’s default styling
            }
        }
    }
    
    private func selectedTab(for company: Company) -> CompaniesHomeView.Tab {
        let dueItems = dueItemsForCompany(company)
        if !dueItems.orders.isEmpty || (!dueItems.orders.isEmpty && !dueItems.tasks.isEmpty) {
            return .orders
        } else if !dueItems.tasks.isEmpty {
            return .tasks
        }
        return .details
    }
    
    private func dueItemsForCompany(_ company: Company) -> (orders: [Order], tasks: [Task]) {
        let today = Calendar.current.startOfDay(for: Date())
        
        let dueOrders = company.orderIDs.compactMap { dataModel.orders[$0] }
            .filter { $0.isOverdue || (Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.isFullyPaid) }
        
        let dueTasks = company.taskIDs.compactMap { dataModel.tasks[$0] }
            .filter { $0.isOverdue || (Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.isDone) }
        
        return (dueOrders, dueTasks)
    }
    
    private var statusDisplayName: String {
        switch status {
        case .activeClient:
            return "Clients"
        case .warmLead:
            return "Warm Leads"
        case .coldLead:
            return "Cold Leads"
        case .ghosting:
            return "Them Bi**hes Ghosting Me"
        case .closedLost:
            return "Not Interested"
        }
    }
}


//MARK: CompanyRow
struct CompanyRow: View {
    @EnvironmentObject var dataModel: DataModel
    var company: Company
    @Binding var selectedCompany: Company?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool
    
    var body: some View {
        HStack {
            Text(company.country.countryCode)
                .font(.caption2)
                .padding(3)
                .background(RoundedRectangle(cornerRadius: 5).fill(.secondary).opacity(0.3))
                .foregroundStyle(Color.secondary)
            
            Text(company.name)
            
            if dataModel.ordersForCompany(company).contains(where: { $0.isOverdue }) || dataModel.tasksForCompany(company).contains(where: { $0.isOverdue }) {
                
                let overdueOrderCount = dataModel.ordersForCompany(company).count(where: { $0.isOverdue })
                let overdueTaskCount = dataModel.tasksForCompany(company).count(where: { $0.isOverdue })
                let overdueItems = overdueOrderCount + overdueTaskCount
                
                Text("\(overdueItems)")
                    .font(.caption2)
                    .padding(6)
                    .foregroundStyle(.red)
                    .background(Color.red.opacity(0.3))
                    .clipShape(Circle())
            }
        }
        
        .contextMenu {
            Button {
                selectedCompany = company
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showEditAccountSheet = true
                }
            } label: {
                Label("Edit Company", systemImage: "square.and.pencil")
            }
            
            Button {
                selectedCompany = company
                showAddOrderSheet = true
            } label: {
                Label("Add new Order", systemImage: "dollarsign.circle")
            }
            
            Button {
                selectedCompany = company
                showAddTaskSheet = true
            } label: {
                Label("Add new task", systemImage: "checklist")
            }
            
            Button {
                selectedCompany = company
                showAddInteractionSheet = true
            } label: {
                Label("Add new Interaction", systemImage: "plus.bubble")
            }
            
            Button {
                selectedCompany = company
                showAddContactSheet = true
            } label: {
                Label("Add new Contact", systemImage: "person.crop.circle.badge.plus")
            }
        }
    }
}

struct EmptyStateView: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Wow, such empty.")
                .font(.title2)
                .fontWeight(.bold)
            Button {
                showAlert.toggle()
            } label: {
                Image("confusedGhosty")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .primary.opacity(0.5) , radius: 15)
                    .padding(.horizontal, 50)
            }
            
            Text(emptyStateMessage)
                .multilineTextAlignment(.center)
                .padding(20)
            
            Spacer()
            Spacer()
        }
        .alert("You think you're funny?", isPresented: $showAlert) {
            } message: {
            Text("Just tap the + in the top right corner, OK?")
        }
    }
    
    private var emptyStateMessage: AttributedString {
        var message = AttributedString("Frankly, you should be embarrassed.\nI mean, you haven't found even ")
        message.font = .caption
        message.foregroundColor = .secondary
        
        var oneWord = AttributedString("one")
        oneWord.font = .caption.italic()
        oneWord.foregroundColor = .secondary
        
        message.append(oneWord)
        
        var potentialClient = AttributedString(" potential client?\n\nAnyway, see that ")
        potentialClient.font = .caption
        potentialClient.foregroundColor = .secondary
        message.append(potentialClient)
        
        var plusSign = AttributedString("+")
        plusSign.foregroundColor = .accentColor
        
        message.append(plusSign)
        
        var endOfMessage = AttributedString(" button in the top right corner?")
        endOfMessage.font = .caption
        endOfMessage.foregroundColor = .secondary
        
        message.append(endOfMessage)
        
        return message
    }
}
