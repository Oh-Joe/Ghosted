import Foundation

struct Company: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var companyType: CompanyType
    var paymentTerms: PaymentTerms
    var country: Country
    var status: Status
    var website: String
    var contactIDs: [UUID]
    var orderIDs: [UUID]
    var interactionIDs: [UUID]
    var taskIDs: [UUID]
    var generalNotes: String
    
    enum CompanyType: String, CaseIterable, Codable {
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
    
    enum PaymentTerms: String, CaseIterable, Codable {
        case prePay = "Pre-pay"
        case days15 = "15 days"
        case days30 = "30 days"
        case days60 = "60 days"
        case days61 = "61 days"
        case days90 = "90 days"
        case days120 = "120 days"
        case days180 = "180 days"
        case days360 = "360 days"
        
        var paymentTermsInt: Int {
            switch self {
            case .prePay:
                return 0
            case .days15:
                return 15
            case .days30:
                return 30
            case .days60:
                return 60
            case .days61:
                return 61
            case .days90:
                return 90
            case .days120:
                return 120
            case .days180:
                return 180
            case .days360:
                return 360
            }
        }
    }
}
