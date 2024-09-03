//
//  AccountListView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isOn = false
    @State private var audioManager = AVAudioPlayerManager()
    @State private var showAddAccountSheet = false
    @State var showAlert: Bool = false
    @State private var selectedAccount: Account? = nil
    @State private var sectionExpandedStates: [Account.Status: Bool] = [
        .activeClient: true,
        .warmLead: true,
        .coldLead: true,
        .closedLost: true,
        .ghosting: true
        
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
                } message: {Text("Just tap the + in the top right corner, will you?")
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
                            selectedAccount: $selectedAccount
                        )
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedAccount = nil
                    showAddAccountSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showAddAccountSheet) {
                    AddAccountView(accountToEdit: selectedAccount)
                        .environmentObject(modelData)
                }
            }
        }
        .sheet(item: $selectedAccount) { accountToEdit in
            AddAccountView(accountToEdit: accountToEdit)
                .environmentObject(modelData)
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

struct AccountSectionView: View {
    var status: Account.Status
    var accounts: [Account]
    var accountCount: Int
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    var deleteAction: (IndexSet) -> Void
    
    @Binding var selectedAccount: Account?
    
    var body: some View {
        
        if !accounts.isEmpty {
            
            Section(header: sectionHeaderView) {
                if isExpanded {
                    ForEach(accounts) { account in
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            AccountRow(account: account, selectedAccount: $selectedAccount)
                        }
                    }
                    .onDelete(perform: deleteAction)
                    
                }
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
        case .closedLost:
            return "Not Interested"
        case .ghosting:
            return "Them Bitches Ghosting Me"
            
        }
    }
}

struct AccountRow: View {
    var account: Account
    @Binding var selectedAccount: Account?
    
    var body: some View {
        HStack {
            Text(account.name)
            Spacer()
        }
        .contextMenu {
            Button("Edit Account") {
                selectedAccount = account
            }
        }
    }
}

struct AccountListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView()
            .environmentObject(ModelData())
    }
}
