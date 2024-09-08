//
//  TaskRowView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/8/24.
//

import SwiftUI

struct TaskRowView: View {
    
    var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: task.isOverdue ? "xmark.circle" : "checkmark.circle")
                .foregroundStyle(task.isOverdue ? .red : task.isDone ? .green : .secondary)
            Text(task.title)
            Spacer()
            Text(task.dueDate, format: .dateTime.day().month(.abbreviated).year())
        }
    }
}

#Preview {
    TaskRowView(task: Task(id: UUID(), title: "Follow up", contents: "Make sure to ask about the TPS reports", isDone: false, dueDate: Date.now))
}
