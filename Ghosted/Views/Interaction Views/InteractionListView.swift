//
//  InteractionListView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct InteractionListView: View {
    @State private var isShowingAddInteractionSheet: Bool = false
    @State private var showInteractionSheet: Bool = false
    @State private var selectedInteraction: Interaction? = nil
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddInteractionSheet.toggle()
                    } label: {
                        Label("New Interaction", systemImage: "plus.bubble.fill")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddInteractionSheet) {
                        AddInteractionView(account: account)
                    }
                    if !account.interactions.isEmpty {
                        ForEach(account.interactions.sorted(by: { $0.date > $1.date }), id: \.id) { interaction in
                            
                            Button {
                                selectedInteraction = interaction
                                showInteractionSheet = true
                            } label: {
                                HStack {
                                    Text(interaction.date, format: .dateTime.month(.abbreviated).day().year())
                                    Text(" -  \(interaction.title)")
                                }
                                .foregroundStyle(Color.primary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            }
                        }
                    }
                } header: {
                    Text("") // no need to show anything, but I like the extra space
                }
            }
            .navigationTitle(account.name)
            .sheet(isPresented: Binding(
                get: { showInteractionSheet && selectedInteraction != nil },
                set: { newValue in showInteractionSheet = newValue }
            )) {
                InteractionDetailView(interaction: selectedInteraction!)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

