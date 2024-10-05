import Foundation

struct Interaction: Hashable, Codable, Identifiable {
    var id: UUID
    var date: Date
    var title: String
    var content: String
    var companyID: UUID?
}
