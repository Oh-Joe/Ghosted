import SwiftUI

struct AddInteractionView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @State var date: Date = Date()
    @State private var title: String = ""
    @State private var content: String = ""
    
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case title
        case content
    }
    
    var company: Company
    
    var isFormValid: Bool {
        !title.isEmpty && !content.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date",
                           selection: $date,
                           displayedComponents: [.date]
                )
                TextField("Title", text: $title)
                    .focused($focusField, equals: .title)
                    .onSubmit {
                        focusField = .content
                    }
                    .submitLabel(.next)
                TextEditor(text: $content)
                    .focused($focusField, equals: .content)
                    .submitLabel(.done)
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
                            content: content,
                            companyID: company.id
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
