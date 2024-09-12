import SwiftUI

struct TaskListView: View {
    
    @State private var isShowingAddTaskSheet: Bool = false
    @State private var showTaskSheet: Bool = false
    @State private var selectedTask: Task? = nil
    var account: Account
    
    // Function to get days between two dates
    private func daysBetween(_ date1: Date, and date2: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: date1, to: date2).day
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddTaskSheet.toggle()
                    } label: {
                        Label("New Task", systemImage: "checklist")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddTaskSheet) {
                        AddTaskView(account: account)
                    }
                }
                
                // Past due tasks
                let pastDueTasks = account.tasks.filter {
                    $0.isOverdue
                }
                if !pastDueTasks.isEmpty {
                    Section {
                        ForEach(pastDueTasks.sorted(by: { $0.dueDate > $1.dueDate })) { task in
                            taskButton(for: task)
                        }
                    } header: {
                        Text("Past Due")
                    }
                }
                
                // Tasks due in the next 7 days
                let upcomingTasks = account.tasks.filter {
                    if let days = daysBetween(Date.now, and: $0.dueDate), !$0.isDone {
                        return days > 0 && days <= 7
                    }
                    return false
                }
                
                if !upcomingTasks.isEmpty {
                    Section {
                        ForEach(upcomingTasks.sorted(by: { $0.dueDate > $1.dueDate })) { task in
                            taskButton(for: task)
                        }
                    } header: {
                        Text("Due in the Next 7 Days")
                    }
                }
                
                // Tasks due in the next 7-30 days
                let laterTasks = account.tasks.filter {
                    if let days = daysBetween(Date.now, and: $0.dueDate), !$0.isDone {
                        return days > 7 && days <= 30
                    }
                    return false
                }
                if !laterTasks.isEmpty {
                    Section {
                        ForEach(laterTasks.sorted(by: { $0.dueDate > $1.dueDate })) { task in
                            taskButton(for: task)
                        }
                    } header: {
                        Text("7-30 Days Out")
                    }
                }
                
                // Tasks due after 30 days
                let farTasks = account.tasks.filter {
                    if let days = daysBetween(Date.now, and: $0.dueDate), !$0.isDone {
                        return days > 30
                    }
                    return false
                }
                if !farTasks.isEmpty {
                    Section {
                        ForEach(farTasks.sorted(by: { $0.dueDate > $1.dueDate })) { task in
                            taskButton(for: task)
                        }
                    } header: {
                        Text("30+ Days Out")
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { showTaskSheet && selectedTask != nil },
                set: { newValue in showTaskSheet = newValue }
            )) {
                if let selectedTaskBinding = Binding($selectedTask) {
                    TaskDetailView(task: selectedTaskBinding)  // Safely unwrap the optional binding
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    // Reusable task button
    private func taskButton(for task: Task) -> some View {
        Button {
            selectedTask = task
            showTaskSheet = true
        } label: {
            TaskRowView(task: task)
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    TaskListView(account: Account(id: UUID(), name: "ACME Co.", accountType: .distri, country: .france, status: .activeClient, website: "www.acme.com", contacts: [], orders: [], interactions: [], tasks: [], generalNotes: ""))
}
