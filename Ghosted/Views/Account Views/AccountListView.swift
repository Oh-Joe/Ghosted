//
//  AccountListView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showAddAccountSheet = false
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
        
        if modelData.accounts.isEmpty {
            VStack {
                Spacer()
                Image(systemName: "tray.fill")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 24))
                    .opacity(0.3)
                    .frame(width: 100)
                    .padding()
                
                var message0: AttributedString {
                    let result = AttributedString("Wow, such empty.\n\n")
                    return result
                }
                
                var message1: AttributedString {
                    var result = AttributedString("Frankly, you should be embarrassed. I mean, even I feel bad for you, and I'm just a stupid app, so…\n\nAnyway, see that ")
                    result.font = .caption
                    result.foregroundColor = .secondary
                    return result
                }
                
                var message2: AttributedString {
                    var result = AttributedString("+")
                    result.foregroundColor = .accentColor
                    return result
                }
                var message3: AttributedString {
                    var result = AttributedString(" sign in the top right corner?\n Why don't you hit it and see what happens, eh?")
                    result.font = .caption
                    result.foregroundColor = .secondary
                    return result
                }
                
                Text(message0 + message1 + message2 + message3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
            }
        }
        
        NavigationStack {
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
    }
    
    // Delete function
    private func deleteAccount(at offsets: IndexSet, for status: Account.Status) {
        for index in offsets {
            let accountToDelete = sortedAccounts(status: status)[index]
            modelData.deleteAccount(accountToDelete)
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
