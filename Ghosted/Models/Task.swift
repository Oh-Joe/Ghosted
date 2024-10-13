import Foundation

struct Task: Hashable, Codable, Identifiable {
    var id: UUID
    var title: String
    var contents: String
    var isDone: Bool
    var companyID: UUID?
    var isOverdue: Bool {
        let startOfToday = Calendar.current.startOfDay(for: Date.now)
        return dueDate < startOfToday && !isDone
    }
    var dueDate: Date
    var completedDate: Date?
}

extension Task {
    static var emptyTask: Task {
        Task(
            id: UUID(),
            title: "",
            contents: "",
            isDone: false,
            dueDate: Date(),
            completedDate: Date()
        )
    }
}
