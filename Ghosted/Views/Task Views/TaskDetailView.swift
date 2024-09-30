import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataModel: DataModel
    
    @State private var task: Task
    let taskId: UUID
    
    init(taskId: UUID) {
        self.taskId = taskId
        _task = State(initialValue: Task.emptyTask) // Placeholder, will be updated in onAppear
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Due:")
                        Spacer()
                        Text(task.dueDate, format: .dateTime.month(.abbreviated).day().year())
                            .fontWeight(.bold)
                            .foregroundStyle(task.isOverdue ? .red : .primary)
                    }
                    HStack {
                        Toggle("Done?", isOn: Binding(
                            get: { task.isDone },
                            set: { newValue in
                                task.isDone = newValue
                                dataModel.updateTask(task)
                            }
                        ))
                    }
                }
                Section {
                    Text(task.contents)
                } header: {
                    Text("Task description")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text(task.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            if let loadedTask = dataModel.tasks[taskId] {
                task = loadedTask
            }
        }
    }
}

