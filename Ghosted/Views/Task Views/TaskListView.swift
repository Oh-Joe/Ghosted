//
//  TaskListView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/8/24.
//

import SwiftUI

struct TaskListView: View {
    
    @State private var isShowingAddTaskSheet: Bool = false
    @State private var showTaskSheet: Bool = false
    @State private var selectedTask: Task? = nil
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddTaskSheet.toggle()
                    } label: {
                        Label("New Task", systemImage: "checklist")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddTaskSheet) {
                        AddTaskView(account: account)
                    }
                    if !account.tasks.isEmpty {
                        ForEach(account.tasks.sorted(by: { $0.dueDate > $1.dueDate })) { task in
                            Button {
                                selectedTask = task
                                showTaskSheet = true
                            } label: {
                                TaskRowView(task: task)
                                    
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                } header: {
                    Text("") // no need to show anything, but I like the extra space
                }
            }
            .navigationTitle(account.name)
            .sheet(isPresented: Binding(
                get: { showTaskSheet && selectedTask != nil },
                set: { newValue in showTaskSheet = newValue }
            )) {
                TaskDetailView(task: selectedTask!)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    TaskListView(account: Account(id: UUID(), name: "ACME Co.", accountType: .distri, country: .france, status: .activeClient, website: "www.acme.com", contacts: [], orders: [], interactions: [], tasks: [], generalNotes: ""))
}
