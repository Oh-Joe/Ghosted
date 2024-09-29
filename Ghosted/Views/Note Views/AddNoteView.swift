import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var noteDate: Date = Date()
    var contact: Contact
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date",
                           selection: $noteDate,
                           displayedComponents: [.date]
                )
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 250)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newNote = Note(
                            id: UUID(),
                            contactID: contact.id,
                            date: noteDate,
                            title: title,
                            content: content
                        )
                        dataModel.addNote(newNote)
                        dismiss()
                    }
                    .disabled(title.isEmpty && content.isEmpty)
                }
            }
        }
    }
}
