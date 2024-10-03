import SwiftUI

struct TaskRowView: View {
    var task: Task
    
    private var taskStatusIcon: (String, Color) {
        if task.isOverdue {
            return ("exclamationmark.triangle.fill", Color.red)
        } else if task.isDone {
            return ("checkmark.circle.fill", .green)
        } else {
            return ("checkmark.circle", .secondary)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: taskStatusIcon.0)
                .foregroundStyle(taskStatusIcon.1)
            Text(task.title)
            Spacer()
            Text(task.dueDate, format: .dateTime.day().month(.abbreviated).year())
        }
        .foregroundStyle(task.isOverdue ? .red : .primary)
    }
}

