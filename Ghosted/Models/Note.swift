import Foundation

struct Note: Hashable, Codable, Identifiable {
    var id: UUID
    var contactID: UUID
    var date: Date
    var title: String
    var content: String
    
    init(id: UUID = UUID(), contactID: UUID, date: Date = Date(), title: String, content: String) {
        self.id = id
        self.contactID = contactID
        self.date = date
        self.title = title
        self.content = content
    }
}

extension Note {
    static var emptyNote: Note {
        Note(contactID: UUID(), title: "", content: "")
    }
}
