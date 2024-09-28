import SwiftUI

//MARK: AccountListView
import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isOn = false
    @State private var audioManager = AVAudioPlayerManager()
    @State private var showAddAccountSheet = false
    @State private var showEditAccountSheet = false
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
                EmptyStateView(showAlert: $showAlert, playSound: playSound)
            } else {
                AccountListContent(
                    sectionExpandedStates: $sectionExpandedStates,
                    selectedCompany: $selectedCompany,
                    showAddOrderSheet: $showAddOrderSheet,
                    showAddContactSheet: $showAddContactSheet,
                    showAddInteractionSheet: $showAddInteractionSheet,
                    showAddTaskSheet: $showAddTaskSheet,
                    showEditAccountSheet: $showEditAccountSheet,
                    deleteAccount: deleteAccount
                )
            }
        }
        .onChange(of: showEditAccountSheet) { _, newValue in
            if !newValue {
                selectedCompany = nil
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedCompany = nil
                    showAddAccountSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddAccountSheet) {
            AddAccountView(isPresented: $showAddAccountSheet, accountToEdit: nil)
                .environmentObject(dataModel)
        }
        .sheet(isPresented: $showEditAccountSheet, onDismiss: {
            selectedCompany = nil
        }) {
            if let accountToEdit = selectedCompany {
                AddAccountView(isPresented: $showEditAccountSheet, accountToEdit: accountToEdit)
                    .environmentObject(dataModel)
            }
        }
        .sheet(isPresented: Binding(
            get: { showAddContactSheet && selectedCompany != nil },
            set: { newValue in showAddContactSheet = newValue }
        )) {
            AddContactView(company: selectedCompany!)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: Binding(
            get: { showAddInteractionSheet && selectedCompany != nil },
            set: { newValue in showAddInteractionSheet = newValue }
        )) {
            AddInteractionView(company: selectedCompany!)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: Binding(
            get: { showAddOrderSheet && selectedCompany != nil },
            set: { newValue in showAddOrderSheet = newValue }
        )) {
            AddOrderView(company: selectedCompany!)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: Binding(
            get: { showAddTaskSheet && selectedCompany != nil },
            set: { newValue in showAddTaskSheet = newValue }
        )) {
            AddTaskView(company: selectedCompany!)
                .presentationDragIndicator(.visible)
        }
    }
    
    private func deleteAccount(at offsets: IndexSet, for status: Company.Status) {
        for index in offsets {
            let accountToDelete = sortedAccounts(status: status)[index]
            dataModel.deleteAccount(accountToDelete)
        }
    }
    
    private func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("Sound file not found")
            return
        }
        
        isOn.toggle()
        audioManager.playSound(with: url) {
            self.isOn.toggle()
        }
    }
    
    private func sortedAccounts(status: Company.Status) -> [Company] {
        return dataModel.companies
            .filter { $0.status == status }
            .sorted { $0.name < $1.name }
    }
}

struct EmptyStateView: View {
    @Binding var showAlert: Bool
    var playSound: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                playSound("Sheeit")
                showAlert.toggle()
            } label: {
                Image("confusedGhosty")
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .primary.opacity(0.5) , radius: 15)
                    .padding(.horizontal, 50)
            }
            
            Text("Wow, such empty.")
            Text(emptyStateMessage)
                .multilineTextAlignment(.center)
                .padding(20)
            
            Spacer()
            Spacer()
        }
        .alert("You think you're funny?", isPresented: $showAlert) {
            Button("OK") {
                playSound("okay")
            }
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
        message.append(AttributedString(" potential client?\n\nAnyway, see that "))
        
        var plusSign = AttributedString("+")
        plusSign.foregroundColor = .accentColor
        
        message.append(plusSign)
        message.append(AttributedString(" sign in the top right corner?"))
        
        return message
    }
}

struct AccountListContent: View {
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
                let accountsForStatus = sortedAccounts(status: status)
                AccountSectionView(
                    status: status,
                    companies: accountsForStatus,
                    accountCount: accountsForStatus.count,
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
    
    private func sortedAccounts(status: Company.Status) -> [Company] {
        return dataModel.companies
            .filter { $0.status == status }
            .sorted { $0.name < $1.name }
    }
}


//MARK: AccountSection
struct AccountSectionView: View {
    var status: Company.Status
    var companies: [Company]
    var accountCount: Int
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    var deleteAction: (IndexSet) -> Void
    
    @Binding var selectedCompany: Company?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool  // New binding for edit company sheet
    
    var body: some View {
        
        if !companies.isEmpty {
            
            Section {
                if isExpanded {
                    ForEach(companies.sorted(by: { $0.country.countryCode < $1.country.countryCode })) { company in
                        NavigationLink(destination: AccountsHomeView(company: company)) {
                            AccountRow(company: company, selectedCompany: $selectedCompany, showAddOrderSheet: $showAddOrderSheet, showAddContactSheet: $showAddContactSheet, showAddInteractionSheet: $showAddInteractionSheet, showAddTaskSheet: $showAddTaskSheet, showEditAccountSheet: $showEditAccountSheet)
                        }
                        .swipeActions {
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
                sectionHeaderView
            }
        }
    }
    
    private var sectionHeaderView: some View {
        HStack {
            HStack {
                Text("\(statusDisplayName)")
                Text("\(accountCount)")
                    .font(.caption)
                    .frame(width: 15, height: 15)
                    .background(Circle().fill(accountCount == 0 ? Color.secondary : Color.accentColor).opacity(0.3))
            }
            Spacer()
            if accountCount > 0 {
                Button(action: toggleExpansion) {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
        }
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
            return "Them Bitches Ghosting Me"
        case .closedLost:
            return "Not Interested"
        }
    }
}

//MARK: AccountRow
struct AccountRow: View {
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
            Spacer()
        }
        .contextMenu {
            Button {
                selectedCompany = company
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showEditAccountSheet = true
                }
            } label: {
                Text("Edit Company")
                Spacer()
                Image(systemName: "square.and.pencil")
            }
            Button {
                selectedCompany = company
                showAddContactSheet = true
            } label: {
                Text("Add new Contact")
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
            }
            Button {
                selectedCompany = company
                showAddInteractionSheet = true
            } label: {
                Text("Add new Interaction")
                Spacer()
                Image(systemName: "plus.bubble")
            }
            Button {
                selectedCompany = company
                showAddOrderSheet = true
            } label: {
                Text("Add new Order")
                Spacer()
                Image(systemName: "dollarsign.circle")
            }
            Button {
                selectedCompany = company
                showAddTaskSheet = true
            } label: {
                Text("Add new Task")
                Spacer()
                Image(systemName: "checklist")
            }
        }
    }
}
