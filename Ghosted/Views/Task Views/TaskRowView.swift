import SwiftUI

struct TaskRowView: View {
    var task: Task
    
    private var taskStatusIcon: (String, Color) {
        if task.isOverdue {
            return ("exclamationmark.triangle.fill", Color.red)
        } else if task.isDone {
            return ("checkmark.circle.fill", .green)
        } else {
            return ("minus.circle", .secondary)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: taskStatusIcon.0)
                .foregroundStyle(taskStatusIcon.1)
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(task.dueDate, format: .dateTime.day().month(.abbreviated).year())
                    .font(.caption)
            }
            Spacer()
            Text(task.contents)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .foregroundStyle(task.isOverdue ? .red : .primary)
    }
}

