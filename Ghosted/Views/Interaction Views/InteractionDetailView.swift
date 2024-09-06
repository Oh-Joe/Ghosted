//
//  InteractionDetailView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/2/24.
//

import SwiftUI

struct InteractionDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    
    var interaction: Interaction
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(interaction.date, format: .dateTime.month(.abbreviated).day().year())
                        .fontWeight(.bold)
                    Divider()
                    ScrollView {
                        Text(interaction.content)
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text(interaction.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(.top, 15)
    }
}


