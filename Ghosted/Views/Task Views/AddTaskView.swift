import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var contents: String = ""
    @State var isDone: Bool = false
    @State var dueDate: Date? = nil
    
    var isFormValid: Bool {
        !contents.isEmpty && !title.isEmpty
    }
    
    var account: Account
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task title", text: $title)
                
                Section {
                    DatePicker("To complete by:", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: .date)
                    Toggle("Done already?", isOn: $isDone)
                }
                Section {
                    TextEditor(text: $contents)
                        .frame(height: 250)
                } header: {
                    Text("Enter a task description below:")
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let newTask = Task(id: UUID(),
                                           title: title,
                                           contents: contents,
                                           isDone: isDone,
                                           dueDate: dueDate ?? Date.now)
                        modelData.addTask(newTask, to: account)
                        modelData.objectWillChange.send()  // Notify observers of the change
                        dismiss()
                    } label : {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

