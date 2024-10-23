import SwiftUI

struct InteractionListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isShowingAddInteractionSheet: Bool = false
    @State private var showInteractionSheet: Bool = false
    @State private var selectedInteraction: Interaction? = nil
    var company: Company
    
    var body: some View {
        List {
            Section {
                Button {
                    isShowingAddInteractionSheet.toggle()
                } label: {
                    Label("New Interaction", systemImage: "plus.bubble.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
            } header: {
                Text("")
            }
            
            
            let interactions = dataModel.interactionsForCompany(company)
            if interactions.isEmpty {
                ContentUnavailableView("Log calls, meetings, etc.", systemImage: "ellipsis.bubble.fill", description: Text("Give your interactions simple titles to easily identify them. Add more details in the desccription field. Swipe left on an interaction to delete."))
                
            } else {
                Section {
                    ForEach(interactions.sorted(by: { $0.date > $1.date })) { interaction in
                        Button {
                            selectedInteraction = interaction
                            showInteractionSheet = true
                        } label: {
                            InteractionRowView(interaction: interaction)
                        }
                    }
                    .onDelete(perform: deleteInteractions)
                }
            }
        }
        .navigationTitle("Interactions")
        .sheet(isPresented: $isShowingAddInteractionSheet) {
            AddInteractionView(company: company)
        }
        .sheet(isPresented: Binding(
            get: { showInteractionSheet && selectedInteraction != nil },
            set: { newValue in showInteractionSheet = newValue }
        )) {
            if let interaction = selectedInteraction {
                InteractionDetailView(interaction: interaction)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func deleteInteractions(at offsets: IndexSet) {
        let interactionsToDelete = offsets.map { dataModel.interactionsForCompany(company).sorted(by: { $0.date > $1.date })[$0] }
        for interaction in interactionsToDelete {
            dataModel.deleteInteraction(interaction)
        }
    }
}
