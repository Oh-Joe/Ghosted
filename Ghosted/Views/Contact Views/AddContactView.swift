//
//  AddContactView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct AddContactView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss

    @State var id = UUID()
    @State var firstName = ""
    @State var lastName = ""
    @State var jobTitle = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var photoName = ""
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }

    var account: Account
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("First name:", text: $firstName)
                TextField("Last name:", text: $lastName)
                TextField("Job:", text: $jobTitle)
                TextField("Email:", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Cell number:", text: $phoneNumber)
                    .keyboardType(.phonePad)
                
            }
            .navigationTitle("New Contact")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let newContact = Contact(
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            jobTitle: jobTitle,
                            email: email,
                            phoneNumber: phoneNumber,
                            notes: []
                        )
                        modelData.addContact(newContact, to: account)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    AddContactView(account: ModelData().accounts[0])
        .environmentObject(ModelData())
}
