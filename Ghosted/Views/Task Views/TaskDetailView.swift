//
//  TaskDetailView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/8/24.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    
    @Binding var task: Task
    
    var account: Account
    
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
                                modelData.updateTask(task, in: account)
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
    }
}
