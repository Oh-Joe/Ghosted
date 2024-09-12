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
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Due:")
                        Spacer()
                        Text(task.dueDate, format: .dateTime.month(.abbreviated).day().year())
                            .fontWeight(.bold)
                            .foregroundStyle(task.dueDate < Date.now ? .red : .primary)
                    }
                    HStack{
                        Text("Done?")
                        Spacer()
                        Button {
                            task.isDone.toggle()
                        } label: {
                            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(task.isDone ? .green : .primary)
                        }
                        
                        
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

#Preview {
    TaskDetailView(task: .constant(Task(id: UUID(), title: "Task title", contents: "Just print the damn thing!", isDone: true, dueDate: Date.now)))
}
