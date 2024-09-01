//
//  ModelView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

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
    var generalNotes: String
//    var interactions: [Note]

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
        case closedLost = "Not Interested"
        case ghosting = "They Ghosting Me 🙄"
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
    
    enum Currency: String, CaseIterable, Codable {
        case eur = "EUR"
        case gbp = "GBP"
        case usd = "USD"
    }
}

//MARK: ModelData class
class ModelData: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var contacts: [Contact] = []
    @Published var orders: [Order] = []
    
    // File paths for JSON files
    internal var accountsFilePath: URL
    internal var contactsFilePath: URL
    internal var ordersFilePath: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        accountsFilePath = documentsDirectory.appendingPathComponent("accounts.json")
        contactsFilePath = documentsDirectory.appendingPathComponent("contacts.json")
        ordersFilePath = documentsDirectory.appendingPathComponent("orders.json")
        
        // Load initial data
        loadAccounts()
        loadContacts()
        loadOrders()
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
    
    private func loadAccounts() {
        accounts = loadJSON(from: accountsFilePath) ?? []
    }
    
    private func loadContacts() {
        contacts = loadJSON(from: contactsFilePath) ?? []
    }
    
    private func loadOrders() {
        orders = loadJSON(from: ordersFilePath) ?? []
    }
}

