import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isShowingAddTaskSheet: Bool = false
    @State private var showTaskSheet: Bool = false
    @State private var selectedTask: Task? = nil
    var company: Company
    
    @State private var sectionExpandedStates: [TaskSection: Bool] = [
        .pastDue: true,
        .today: true,
        .upcoming: true,
        .completed: false
    ]
    
    enum TaskSection: String, CaseIterable {
        case pastDue = "Past Due"
        case today = "Today"
        case upcoming = "Upcoming"
        case completed = "Completed"
    }
    
    var body: some View {
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
            }
            
            ForEach(TaskSection.allCases, id: \.self) { section in
                let tasksForSection = tasksForSection(section)
                if !tasksForSection.isEmpty {
                    TaskSectionView(
                        section: section,
                        tasks: tasksForSection,
                        isExpanded: sectionExpandedStates[section] ?? false,
                        toggleExpansion: {
                            withAnimation {
                                sectionExpandedStates[section]?.toggle()
                            }
                        },
                        selectedTask: $selectedTask,
                        showTaskSheet: $showTaskSheet
                    )
                }
            }
        }
        .navigationTitle("Tasks")
        .sheet(isPresented: $isShowingAddTaskSheet) {
            AddTaskView(company: company)
        }
        .sheet(isPresented: Binding(
            get: { showTaskSheet && selectedTask != nil },
            set: { newValue in showTaskSheet = newValue }
        )) {
            if let selectedTask = selectedTask {
                TaskDetailView(taskId: selectedTask.id)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func tasksForSection(_ section: TaskSection) -> [Task] {
        let tasks = dataModel.tasksForCompany(company)
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        switch section {
        case .pastDue:
            return tasks.filter { $0.isOverdue && !$0.isDone }.sorted(by: { $0.dueDate < $1.dueDate })
        case .today:
            return tasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.isDone }
                .sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        case .upcoming:
            return tasks.filter { $0.dueDate >= tomorrow && !$0.isDone }.sorted(by: { $0.dueDate < $1.dueDate })
        case .completed:
            return tasks.filter { $0.isDone }.sorted(by: { $0.dueDate > $1.dueDate })
        }
    }
}

struct TaskSectionView: View {
    @EnvironmentObject var dataModel: DataModel
    var section: TaskListView.TaskSection
    var tasks: [Task]
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    @Binding var selectedTask: Task?
    @Binding var showTaskSheet: Bool
    
    var body: some View {
        Section {
            if isExpanded {
                ForEach(tasks) { task in
                    Button {
                        selectedTask = task
                        showTaskSheet = true
                    } label: {
                        TaskRowView(task: task)
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete(perform: deleteTasks)
            }
        } header: {
            Button(action: toggleExpansion) {
                HStack {
                    Text(section.rawValue)
                    Text("\(tasks.count)")
                        .font(.caption)
                        .frame(width: 15, height: 15)
                        .background(Circle().fill(Color.accentColor).opacity(0.3))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut, value: isExpanded)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            dataModel.deleteTask(tasks[index])
        }
    }
}
