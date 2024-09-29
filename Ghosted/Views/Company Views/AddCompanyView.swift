import SwiftUI

struct AddCompanyView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var companyType: Company.CompanyType = .distri
    @State private var country: Country = .afghanistan
    @State private var status: Company.Status = .activeClient
    @State private var website: String = ""
    @State private var generalNotes: String = ""
    
    var companyToEdit: Company?
    
    var isEditing: Bool {
        companyToEdit != nil
    }
    
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                CompanyForm(
                    name: $name,
                    companyType: $companyType,
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
                        isPresented = false
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                        isPresented = false
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            if let company = companyToEdit {
                name = company.name
                companyType = company.companyType
                country = company.country
                status = company.status
                website = company.website
                generalNotes = company.generalNotes
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    private func save() {
        let newCompany = Company(
            id: companyToEdit?.id ?? UUID(),
            name: name,
            companyType: companyType,
            country: country,
            status: status,
            website: website,
            contactIDs: companyToEdit?.contactIDs ?? [],
            orderIDs: companyToEdit?.orderIDs ?? [],
            interactionIDs: companyToEdit?.interactionIDs ?? [],
            taskIDs: companyToEdit?.taskIDs ?? [],
            generalNotes: generalNotes
        )
        
        if isEditing {
            dataModel.updateCompany(newCompany)
        } else {
            dataModel.addCompany(newCompany)
        }
    }
}
