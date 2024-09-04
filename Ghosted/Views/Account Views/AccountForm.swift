//
//  AccountForm.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct AccountForm: View {
    @Binding var name: String
    @Binding var accountType: Account.AccountType
    @Binding var country: Country
    @Binding var status: Account.Status
    @Binding var website: String
    @Binding var generalNotes: String
    
    var body: some View {
        Section {
            TextField("Company name (required)", text: $name)
            TextField("Website", text: $website)
                .keyboardType(.URL)
                .autocapitalization(.none)
            Picker("Select account type:", selection: $accountType) {
                Text("What do they do?")
                Divider()
                ForEach(Account.AccountType.allCases, id: \.self) { accountType in
                    Text(accountType.rawValue).tag(accountType)
                }
            }
            Picker("Country:", selection: $country) {
                Text("Where are they based?")
                Divider()
                ForEach(Country.allCases, id: \.self) { country in
                    Text(country.rawValue.capitalized).tag(country)
                }
            }
            Picker("Account status:", selection: $status) {
                Text("They buying yet?")
                Divider()
                ForEach(Account.Status.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
        } header: {
            Text("Account Details")
        }
        
        Section {
            TextEditor(text: $generalNotes)
                .frame(height: 80)
        } header: {
            Text("General Notes")
        }
    }
}
