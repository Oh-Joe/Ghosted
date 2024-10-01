//
//  AccountForm.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct CompanyForm: View {
    @Binding var name: String
    @Binding var companyType: Company.CompanyType
    @Binding var country: Country
    @Binding var status: Company.Status
    @Binding var website: String
    @Binding var generalNotes: String
    
    var body: some View {
        Section {
            TextField("Company name (required)", text: $name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
            TextField("Website", text: $website)
                .autocorrectionDisabled(true)
                .keyboardType(.URL)
                .autocapitalization(.none)
            Picker("Select company type:", selection: $companyType) {
                Text("What do they do?")
                Divider()
                ForEach(Company.CompanyType.allCases, id: \.self) { companyType in
                    Text(companyType.rawValue).tag(companyType)
                }
            }
            Picker("Country:", selection: $country) {
                Text("Where are they based?")
                Divider()
                ForEach(Country.allCases, id: \.self) { country in
                    Text(country.rawValue.capitalized).tag(country)
                }
            }
            Picker("Company status:", selection: $status) {
                Text("They buying yet?")
                Divider()
                ForEach(Company.Status.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
        } header: {
            Text("Company Details")
        }
        
        Section {
            TextEditor(text: $generalNotes)
                .frame(height: 80)
        } header: {
            Text("General Notes")
        }
    }
}