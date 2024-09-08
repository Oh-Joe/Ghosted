//
//  AddAccountView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var accountType: Account.AccountType = .distri
    @State private var country: Country = .afghanistan
    @State private var status: Account.Status = .activeClient
    @State private var website: String = ""
    @State private var generalNotes: String = ""
    
    var accountToEdit: Account?
    
    var isEditing: Bool {
        accountToEdit != nil
    }
    
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                AccountForm(
                    name: $name,
                    accountType: $accountType,
                    country: $country,
                    status: $status,
                    website: $website,
                    generalNotes: $generalNotes
                )
            }
            
            .navigationTitle(isEditing ? "Edit Account" : "Add Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                        
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            if let account = accountToEdit {
                name = account.name
                accountType = account.accountType
                country = account.country
                status = account.status
                website = account.website
                generalNotes = account.generalNotes
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    private func save() {
            let newAccount = Account(
                id: accountToEdit?.id ?? UUID(), // Use existing ID if editing
                name: name,
                accountType: accountType,
                country: country,
                status: status,
                website: website,
                contacts: accountToEdit?.contacts ?? [],
                orders: accountToEdit?.orders ?? [],
                interactions: accountToEdit?.interactions ?? [],
                tasks: accountToEdit?.tasks ?? [],
                generalNotes: generalNotes
            )
            
            if let _ = accountToEdit {
                modelData.updateAccount(newAccount)
            } else {
                modelData.addAccount(newAccount)
            }
        }
}
