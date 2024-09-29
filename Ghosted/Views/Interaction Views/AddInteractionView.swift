import SwiftUI

struct AddInteractionView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @State var date: Date = Date()
    @State private var title: String = ""
    @State private var content: String = ""
    var company: Company
    
    var isFormValid: Bool {
        !date.description.isEmpty && !title.isEmpty && !content.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date",
                           selection: $date,
                           displayedComponents: [.date]
                )
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 250)
            }
            .navigationTitle("New Interaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newInteraction = Interaction(
                            id: UUID(),
                            date: date,
                            title: title,
                            content: content
                        )
                        dataModel.addInteraction(newInteraction, to: company)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}
