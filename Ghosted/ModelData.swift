import Foundation

//MARK: Account
struct Account: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var accountType: AccountType
    var country: Country // enum Country in separate Countries.swift file in Helpers folder
    var status: Status
    var website: String
    var contacts: [Contact]
    var orders: [Order]
    var interactions: [Interaction]
    var tasks: [Task]
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

//MARK: Contact
struct Contact: Hashable, Codable, Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var jobTitle: String
    var email: String
    var phoneNumber: String
    var photoName: String
    var notes: [Note]
    
    struct Note: Hashable, Codable, Identifiable {
        var id: UUID
        var date: Date
        var title: String
        var content: String
    }
}

//MARK: Order
struct Order: Hashable, Codable, Identifiable {
    var id: UUID
    var issuedDate: Date
    var dueDate: Date
    var orderAmount: Double
    var currency: Currency
    var orderNumber: String
    var isFullyPaid: Bool
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

//MARK: Interaction
struct Interaction: Hashable, Codable, Identifiable {
    var id: UUID
    var date: Date
    var title: String
    var content: String
}

//MARK: Task
struct Task: Hashable, Codable, Identifiable {
    var id: UUID
    var title: String
    var contents: String
    var isDone: Bool
    var isOverdue: Bool {
        let startOfToday = Calendar.current.startOfDay(for: Date.now)
        return dueDate < startOfToday && !isDone
    }
    var dueDate: Date
}

//MARK: ModelData class
class ModelData: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var contacts: [Contact] = []
    @Published var orders: [Order] = []
    @Published var interactions: [Interaction] = []
    @Published var tasks: [Task] = []
    
    // File paths for JSON files
    internal var accountsFilePath: URL
    internal var contactsFilePath: URL
    internal var ordersFilePath: URL
    internal var interactionsFilePath: URL
    internal var tasksFilePath: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        accountsFilePath = documentsDirectory.appendingPathComponent("accounts.json")
        contactsFilePath = documentsDirectory.appendingPathComponent("contacts.json")
        ordersFilePath = documentsDirectory.appendingPathComponent("orders.json")
        interactionsFilePath = documentsDirectory.appendingPathComponent("interactions.json")
        tasksFilePath = documentsDirectory.appendingPathComponent("tasks.json")
        
        // Load initial data
        loadAccounts()
        loadContacts()
        loadOrders()
        loadInteractions()
        loadTasks()
    }
    
    internal func saveJSON<T: Encodable>(_ value: T, to fileURL: URL) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save JSON: \(error)")
        }
    }
    
    internal func loadJSON<T: Decodable>(from fileURL: URL) -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("Failed to load JSON: \(error)")
            return nil
        }
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        saveJSON(accounts, to: accountsFilePath)
    }
    
    func updateAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
            saveJSON(accounts, to: accountsFilePath)
        }
    }

    func deleteAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts.remove(at: index)
            saveJSON(accounts, to: accountsFilePath)
        }
    }
    
    func addContact(_ contact: Contact, to account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].contacts.append(contact)
            saveJSON(accounts, to: accountsFilePath)
        } else {
            print("Account not found")
        }
    }
    
    func addOrder(_ order: Order, to account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].orders.append(order)
            saveJSON(accounts, to: accountsFilePath)
        } else {
            print("Account not found")
        }
    }
    
    func addInteraction(_ interaction: Interaction, to account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].interactions.append(interaction)
            saveJSON(accounts, to: accountsFilePath)
        } else {
            print("Account not found")
        }
    }
    
    func addTask(_ task: Task, to account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].tasks.append(task)
            saveJSON(accounts, to: accountsFilePath)
        } else {
            print("Account not found")
        }
    }
    
    func addNoteToContact(_ note: Contact.Note, to contact: Contact) {
        // Find the account containing the contact
        if let accountIndex = accounts.firstIndex(where: { $0.contacts.contains(where: { $0.id == contact.id }) }) {
            // Find the contact in the account
            if let contactIndex = accounts[accountIndex].contacts.firstIndex(where: { $0.id == contact.id }) {
                // Append the note to the contact's notes array
                accounts[accountIndex].contacts[contactIndex].notes.append(note)
                // Save the accounts array to disk
                saveJSON(accounts, to: accountsFilePath)
            } else {
                print("Contact not found in the account")
            }
        } else {
            print("Account not found for the given contact")
        }
    }
    
    
    func deleteNoteFromContact(_ note: Contact.Note, from contact: Contact) {
        if let accountIndex = accounts.firstIndex(where: { $0.contacts.contains(where: { $0.id == contact.id }) }) {
            if let contactIndex = accounts[accountIndex].contacts.firstIndex(where: { $0.id == contact.id }) {
                if let noteIndex = accounts[accountIndex].contacts[contactIndex].notes.firstIndex(where: { $0.id == note.id }) {
                    accounts[accountIndex].contacts[contactIndex].notes.remove(at: noteIndex)
                    saveJSON(accounts, to: accountsFilePath)
                }
            }
        } else {
            print("Contact not found")
        }
    }
    
    func updateNoteInContact(_ updatedNote: Contact.Note, in contact: Contact) {
        if let accountIndex = accounts.firstIndex(where: { $0.contacts.contains(where: { $0.id == contact.id }) }) {
            if let contactIndex = accounts[accountIndex].contacts.firstIndex(where: { $0.id == contact.id }) {
                if let noteIndex = accounts[accountIndex].contacts[contactIndex].notes.firstIndex(where: { $0.id == updatedNote.id }) {
                    accounts[accountIndex].contacts[contactIndex].notes[noteIndex] = updatedNote
                    saveJSON(accounts, to: accountsFilePath)
                }
            }
        } else {
            print("Contact not found")
        }
    }
    
    func updateTask(_ updatedTask: Task, in account: Account) {
        if let accountIndex = accounts.firstIndex(where: { $0.id == account.id }) {
            if let taskIndex = accounts[accountIndex].tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                accounts[accountIndex].tasks[taskIndex] = updatedTask
                saveJSON(accounts, to: accountsFilePath)  // Save changes to file
            } else {
                print("Task not found in the account")
            }
        } else {
            print("Account not found for the given task")
        }
    }

    private func loadAccounts() {
        accounts = loadJSON(from: accountsFilePath) ?? []
    }
    
    private func loadContacts() {
        contacts = loadJSON(from: contactsFilePath) ?? []
    }
    
    private func loadOrders() {
        orders = loadJSON(from: ordersFilePath) ?? []
    }
    
    private func loadInteractions() {
        interactions = loadJSON(from: interactionsFilePath) ?? []
    }
    
    private func loadTasks() {
        tasks = loadJSON(from: tasksFilePath) ?? []
    }

}

