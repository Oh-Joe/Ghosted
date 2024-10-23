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
                        isShowingAddContactSheet = true
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
                
                let contacts = dataModel.contactsForCompany(company)
                if contacts.isEmpty {
                    ContentUnavailableView("No one yet", systemImage: "figure.fall", description: Text("Add contacts and their details. For each, add notes to remember key details or little tidbits that you want to remember. Swipe left on a contact to delete."))
                } else {
                Section {
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
