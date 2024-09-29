import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isShowingAddContactSheet: Bool = false
    var company: Company
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddContactSheet.toggle()
                    } label: {
                        Label("New Contact", systemImage: "person.crop.circle.badge.plus")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddContactSheet) {
                        AddContactView(isPresented: $isShowingAddContactSheet, company: company)
                    }
                } header: {
                    Text("") // just for the space
                }
                
                Section {
                    let contacts = dataModel.contactsForCompany(company)
                    if !contacts.isEmpty {
                        ForEach(contacts, id: \.id) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                            }
                        }
                        .onDelete(perform: deleteContacts)
                    } 
                }
            }
            .navigationTitle(company.name)
        }
    }
    
    private func deleteContacts(at offsets: IndexSet) {
        let contactsToDelete = offsets.map { dataModel.contactsForCompany(company)[$0] }
        for contact in contactsToDelete {
            dataModel.deleteContact(contact)
        }
    }
}
