import Foundation

struct Company: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var accountType: AccountType
    var country: Country
    var status: Status
    var website: String
    var contactIDs: [UUID]
    var orderIDs: [UUID]
    var interactionIDs: [UUID]
    var taskIDs: [UUID]
    var generalNotes: String
    
    enum AccountType: String, CaseIterable, Codable {
        case distri = "Distributor"
        case reseller = "Reseller"
        case kol = "Key Opinion Leader"
        case brand = "Brand"
    }
    
    enum Status: String, CaseIterable, Codable {
        case activeClient = "Active Client"
        case warmLead = "Warm Lead"
        case coldLead = "Cold Lead"
        case ghosting = "They Ghosting Me 🙄"
        case closedLost = "Not Interested"
    }
}
