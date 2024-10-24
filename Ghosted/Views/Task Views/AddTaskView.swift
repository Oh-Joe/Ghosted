import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var contents: String = ""
    @State private var dueDate: Date = Date()
    var company: Company
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                TextEditor(text: $contents)
                    .frame(height: 250)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = Task(
                            id: UUID(),
                            title: title,
                            contents: contents,
                            isDone: false,
                            companyID: company.id,
                            dueDate: dueDate,
                            completedDate: dueDate
                        )
                        dataModel.addTask(newTask, to: company)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}
