//
//  ContactListView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct ContactListView: View {
    @State private var isShowingAddContactSheet: Bool = false
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddContactSheet.toggle()
                    } label: {
                        Label("New Contact", systemImage: "person.crop.circle.badge.plus")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddContactSheet) {
                        AddContactView(account: account)
                    }
                    if !account.contacts.isEmpty {
                        ForEach(account.contacts, id: \.id) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                            }
                        }
                    }
                } header: {
                    Text("") // no need to show anything, but I like the extra space
                }
            }
            .navigationTitle(account.name)
        }
    }
}
