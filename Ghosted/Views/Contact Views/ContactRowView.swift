//
//  ContactRowView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct ContactRowView: View {
    @EnvironmentObject var modelData: ModelData
    var contact: Contact
    var rando: Int = Int.random(in: 1...15)
    
    var body: some View {
        HStack {
            Image(contact.photoName)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                Text("\(contact.firstName) ") + Text(contact.lastName).fontWeight(.bold)
                Text(contact.jobTitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ContactRowView(contact: ModelData().contacts[0])
        .environmentObject(ModelData())
}
