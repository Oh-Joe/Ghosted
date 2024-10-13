import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataModel: DataModel
    
    @Binding var task: Task
    @State private var localTask: Task
    
    var company: Company
    init(task: Binding<Task>, company: Company) {
        self._task = task
        self._localTask = State(initialValue: task.wrappedValue)
        self.company = company
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
                        Toggle("Done?", isOn: $localTask.isDone)
                            .onChange(of: localTask.isDone) { oldValue, isOn in
                                if isOn {
                                    localTask.completedDate = Date()
                                } else {
                                    localTask.completedDate = nil
                                }
                            }
                    }
                    if localTask.isDone {
                        DatePicker("Completion date:", selection: Binding(
                            get: { localTask.completedDate ?? Date() },
                            set: { localTask.completedDate = $0 }
                        ), displayedComponents: .date)
                    }
                } header: {
                    Text("Details")
                }
                
                Section {
                    Text(task.contents)
                } header: {
                    Text("Description")
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
        .onDisappear {
            task = localTask
        dataModel.updateTask(localTask)
        }
    }
}

