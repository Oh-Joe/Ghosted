import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var accountType: Company.AccountType = .distri
    @State private var country: Country = .afghanistan
    @State private var status: Company.Status = .activeClient
    @State private var website: String = ""
    @State private var generalNotes: String = ""
    
    var accountToEdit: Company?
    
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
            
            .navigationTitle(isEditing ? "Edit Company" : "Add Company")
            .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    isPresented = false  // Update this line
                                    dismiss()
                                }, label: {
                                    Text("Cancel")
                                        .foregroundStyle(Color.red)
                                })
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button {
                                    save()
                                    isPresented = false  // Add this line
                                    dismiss()
                                } label: {
                                    Text("Save")
                                }
                                .disabled(!isFormValid)
                            }
                        }
                    }
        .onAppear {
            if let company = accountToEdit {
                name = company.name
                accountType = company.accountType
                country = company.country
                status = company.status
                website = company.website
                generalNotes = company.generalNotes
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    private func save() {
            let newAccount = Company(
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
                dataModel.updateAccount(newAccount)
            } else {
                dataModel.addAccount(newAccount)
            }
        }
}
