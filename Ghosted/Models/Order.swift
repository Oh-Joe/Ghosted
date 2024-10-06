import Foundation

struct Order: Hashable, Codable, Identifiable {
    var id: UUID
    var issuedDate: Date
    var dueDate: Date
    var orderAmount: Double
    var currency: Currency
    var orderNumber: String
    var isFullyPaid: Bool
    var paidDate: Date
    var companyID: UUID?
    var isOverdue: Bool {
            let startOfToday = Calendar.current.startOfDay(for: Date())
            return dueDate < startOfToday && !isFullyPaid
        }
    
    enum Currency: String, CaseIterable, Codable, Identifiable {
        case eur = "EUR"
        case gbp = "GBP"
        case usd = "USD"
        
        var id: String { self.rawValue }
    }
    
    enum PaymentStatus: String, CaseIterable, Codable {
        case overdue
        case open
        case paid
    }
}
