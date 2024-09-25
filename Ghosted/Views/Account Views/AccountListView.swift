import SwiftUI

//MARK: AccountListView
struct AccountListView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isOn = false
    @State private var audioManager = AVAudioPlayerManager()
    @State private var showAddAccountSheet = false
    @State private var showEditAccountSheet = false
    @State private var selectedAccount: Account? = nil
    @State private var showAddOrderSheet: Bool = false
    @State private var showAddContactSheet: Bool = false
    @State private var showAddInteractionSheet: Bool = false
    @State private var showAddTaskSheet: Bool = false
    @State var showAlert: Bool = false
    
    @State private var sectionExpandedStates: [Account.Status: Bool] = [
        .activeClient: true,
        .warmLead: true,
        .coldLead: true,
        .ghosting: true,
        .closedLost: true
    ]
    
    // Sort accounts by status, return array of Account
    private func sortedAccounts(status: Account.Status) -> [Account] {
        return modelData.accounts
            .filter { $0.status == status }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        
        NavigationStack {
            if modelData.accounts.isEmpty {
                VStack {
                    Spacer()
                    Button {
                        playSound(soundName: "Sheeit")
                        showAlert.toggle()
                    } label: {
                        Image("confusedGhosty")
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .primary.opacity(0.5) , radius: 15)
                            .padding(.horizontal, 50)
                    }
                    
                    var message1: AttributedString {
                        var result = AttributedString("Frankly, you should be embarrassed.\nI mean, you haven't found even ")
                        result.font = .caption
                        result.foregroundColor = .secondary
                        return result
                    }
                    var message2: AttributedString {
                        var result = AttributedString("one")
                        result.font = .caption.italic()
                        result.foregroundColor = .secondary
                        return result
                    }
                    var message3: AttributedString {
                        var result = AttributedString(" potential client?\n\nAnyway, see that ")
                        result.font = .caption
                        result.foregroundColor = .secondary
                        return result
                    }
                    var message4: AttributedString {
                        var result = AttributedString("+")
                        result.foregroundColor = .accentColor
                        return result
                    }
                    var message5: AttributedString {
                        var result = AttributedString(" sign in the top right corner?")
                        result.font = .caption
                        result.foregroundColor = .secondary
                        return result
                    }
                    
                    Text("Wow, such empty.")
                    Text(message1 + message2 + message3 + message4 + message5)
                        .multilineTextAlignment(.center)
                        .padding(20)
                    
                    Spacer()
                    Spacer()
                }
                .alert("You think you're funny?",
                       isPresented: $showAlert
                ) {
                    Button("OK") {
                        playSound(soundName: "okay")
                    }
                } message: {Text("Just tap the + in the top right corner, OK?")
                }
            } else {
                List {
                    ForEach(Account.Status.allCases, id: \.self) { status in
                        let accountsForStatus = sortedAccounts(status: status)
                        AccountSectionView(
                            status: status,
                            accounts: accountsForStatus,
                            accountCount: accountsForStatus.count,
                            isExpanded: sectionExpandedStates[status] ?? false,
                            toggleExpansion: {
                                withAnimation {
                                    sectionExpandedStates[status]?.toggle()
                                }
                            },
                            deleteAction: { indexSet in
                                deleteAccount(at: indexSet, for: status)
                            },
                            selectedAccount: $selectedAccount,
                            showAddOrderSheet: $showAddOrderSheet,
                            showAddContactSheet: $showAddContactSheet,
                            showAddInteractionSheet: $showAddInteractionSheet,
                            showAddTaskSheet: $showAddTaskSheet,
                            showEditAccountSheet: $showEditAccountSheet // Pass showEditAccountSheet binding
                        )
                    }
                }
            }
        }
        .onChange(of: showEditAccountSheet) { _, newValue in
            if !newValue {
                selectedAccount = nil
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedAccount = nil
                    showAddAccountSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddAccountSheet) {
            AddAccountView(isPresented: $showAddAccountSheet, accountToEdit: nil)
                .environmentObject(modelData)
        }
        .sheet(isPresented: $showEditAccountSheet, onDismiss: {
            selectedAccount = nil  // Reset selectedAccount when the sheet is dismissed
        }) {
            if let accountToEdit = selectedAccount {
                AddAccountView(isPresented: $showEditAccountSheet, accountToEdit: accountToEdit)
                    .environmentObject(modelData)
            }
        }
        
        
        
        
        // Add sheets for adding order, contact, and interaction
        .sheet(isPresented: Binding(
            get: { showAddContactSheet && selectedAccount != nil },
            set: { newValue in showAddContactSheet = newValue }
        )) {
            AddContactView(account: selectedAccount!)
                .presentationDragIndicator(.visible)
        }
        
        .sheet(isPresented: Binding(
            get: { showAddInteractionSheet && selectedAccount != nil },
            set: { newValue in showAddInteractionSheet = newValue }
        )) {
            AddInteractionView(account: selectedAccount!)
                .presentationDragIndicator(.visible)
        }
        
        .sheet(isPresented: Binding(
            get: { showAddOrderSheet && selectedAccount != nil },
            set: { newValue in showAddOrderSheet = newValue }
        )) {
            AddOrderView(account: selectedAccount!)
                .presentationDragIndicator(.visible)
        }
        
        .sheet(isPresented: Binding(
            get: { showAddTaskSheet && selectedAccount != nil },
            set: { newValue in showAddTaskSheet = newValue }
        )) {
            AddTaskView(account: selectedAccount!)
                .presentationDragIndicator(.visible)
        }
    }
    
    // Delete function
    private func deleteAccount(at offsets: IndexSet, for status: Account.Status) {
        for index in offsets {
            let accountToDelete = sortedAccounts(status: status)[index]
            modelData.deleteAccount(accountToDelete)
        }
    }
    
    private func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("Sound file not found")
            return
        }
        
        isOn.toggle() // Toggle before playing the sound
        audioManager.playSound(with: url) {
            self.isOn.toggle() // Toggle after the sound finishes
        }
    }
}

//MARK: AccountSection
struct AccountSectionView: View {
    var status: Account.Status
    var accounts: [Account]
    var accountCount: Int
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    var deleteAction: (IndexSet) -> Void
    
    @Binding var selectedAccount: Account?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool  // New binding for edit account sheet
    
    var body: some View {
        
        if !accounts.isEmpty {
            
            Section {
                if isExpanded {
                    ForEach(accounts.sorted(by: { $0.country.countryCode < $1.country.countryCode })) { account in
                        NavigationLink(destination: AccountsHomeView(account: account)) {
                            AccountRow(account: account, selectedAccount: $selectedAccount, showAddOrderSheet: $showAddOrderSheet, showAddContactSheet: $showAddContactSheet, showAddInteractionSheet: $showAddInteractionSheet, showAddTaskSheet: $showAddTaskSheet, showEditAccountSheet: $showEditAccountSheet)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = accounts.firstIndex(where: { $0.id == account.id }) {
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
    var account: Account
    @Binding var selectedAccount: Account?
    @Binding var showAddOrderSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var showAddInteractionSheet: Bool
    @Binding var showAddTaskSheet: Bool
    @Binding var showEditAccountSheet: Bool
    
    var body: some View {
        HStack {
            Text(account.country.countryCode)
                .font(.caption2)
                .padding(3)
                .background(RoundedRectangle(cornerRadius: 5).fill(.secondary).opacity(0.3))
                .foregroundStyle(Color.secondary)
            Text(account.name)
            Spacer()
        }
        .contextMenu {
            Button {
                selectedAccount = account
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showEditAccountSheet = true
                }
            } label: {
                Text("Edit Account")
                Spacer()
                Image(systemName: "square.and.pencil")
            }
            Button {
                selectedAccount = account
                showAddContactSheet = true
            } label: {
                Text("Add new Contact")
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
            }
            Button {
                selectedAccount = account
                showAddInteractionSheet = true
            } label: {
                Text("Add new Interaction")
                Spacer()
                Image(systemName: "plus.bubble")
            }
            Button {
                selectedAccount = account
                showAddOrderSheet = true
            } label: {
                Text("Add new Order")
                Spacer()
                Image(systemName: "dollarsign.circle")
            }
            Button {
                selectedAccount = account
                showAddTaskSheet = true
            } label: {
                Text("Add new Task")
                Spacer()
                Image(systemName: "checklist")
            }
        }
    }
}
