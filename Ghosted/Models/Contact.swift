import Foundation

struct Contact: Hashable, Codable, Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var jobTitle: String
    var email: String
    var phoneNumber: String
    var photoName: String
    var companyID: UUID?
}
