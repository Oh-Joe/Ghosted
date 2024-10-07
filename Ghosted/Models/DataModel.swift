import Foundation
import UIKit

class DataModel: ObservableObject {
    @Published var companies: [Company] = []
    @Published var contacts: [UUID: Contact] = [:]
    @Published var orders: [UUID: Order] = [:]
    @Published var interactions: [UUID: Interaction] = [:]
    @Published var tasks: [UUID: Task] = [:]
    @Published var notes: [UUID: Note] = [:]
    
    // File paths for JSON files
    private var companiesFilePath: URL
    private var contactsFilePath: URL
    private var ordersFilePath: URL
    private var interactionsFilePath: URL
    private var tasksFilePath: URL
    private var notesFilePath: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        companiesFilePath = documentsDirectory.appendingPathComponent("companies.json")
        contactsFilePath = documentsDirectory.appendingPathComponent("contacts.json")
        ordersFilePath = documentsDirectory.appendingPathComponent("orders.json")
        interactionsFilePath = documentsDirectory.appendingPathComponent("interactions.json")
        tasksFilePath = documentsDirectory.appendingPathComponent("tasks.json")
        notesFilePath = documentsDirectory.appendingPathComponent("notes.json")
        
        // Load initial data
        loadAll()
    }
    
    // MARK: - Saving and Loading
    
    private func saveJSON<T: Encodable>(_ value: T, to fileURL: URL) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save JSON: \(error)")
        }
    }
    
    private func loadJSON<T: Decodable>(from fileURL: URL) -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("Failed to load JSON: \(error)")
            return nil
        }
    }
    
    private func loadAll() {
        companies = loadJSON(from: companiesFilePath) ?? []
        contacts = Dictionary(uniqueKeysWithValues: (loadJSON(from: contactsFilePath) as [Contact]? ?? []).map { ($0.id, $0) })
        orders = Dictionary(uniqueKeysWithValues: (loadJSON(from: ordersFilePath) as [Order]? ?? []).map { ($0.id, $0) })
        interactions = Dictionary(uniqueKeysWithValues: (loadJSON(from: interactionsFilePath) as [Interaction]? ?? []).map { ($0.id, $0) })
        tasks = Dictionary(uniqueKeysWithValues: (loadJSON(from: tasksFilePath) as [Task]? ?? []).map { ($0.id, $0) })
        notes = Dictionary(uniqueKeysWithValues: (loadJSON(from: notesFilePath) as [Note]? ?? []).map { ($0.id, $0) })
    }
    
    private func saveAll() {
        saveJSON(companies, to: companiesFilePath)
        saveJSON(Array(contacts.values), to: contactsFilePath)
        saveJSON(Array(orders.values), to: ordersFilePath)
        saveJSON(Array(interactions.values), to: interactionsFilePath)
        saveJSON(Array(tasks.values), to: tasksFilePath)
        saveJSON(Array(notes.values), to: notesFilePath)
    }
    
    // MARK: - Image Saving
    
    func saveImage(_ image: UIImage, forContact contactID: UUID) -> String? {
        let imageName = "\(contactID.uuidString).jpg"
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        do {
            try data.write(to: fileURL)
            return imageName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    // MARK: - Company Methods
    
    func addCompany(_ company: Company) {
        companies.append(company)
        saveAll()
    }
    
    func updateCompany(_ company: Company) {
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index] = company
            saveAll()
        }
    }
    
    func deleteCompany(_ company: Company) {
        // Remove associated contacts, orders, interactions, and tasks
        for contactID in company.contactIDs {
            contacts.removeValue(forKey: contactID)
        }
        for orderID in company.orderIDs {
            orders.removeValue(forKey: orderID)
        }
        for interactionID in company.interactionIDs {
            interactions.removeValue(forKey: interactionID)
        }
        for taskID in company.taskIDs {
            tasks.removeValue(forKey: taskID)
        }
        
        companies.removeAll { $0.id == company.id }
        saveAll()
    }
    
    // MARK: - Contact Methods
    
    func addContact(_ contact: Contact, with image: UIImage?, to company: Company) {
        var newContact = contact
        if let image = image {
            newContact.photoName = saveImage(image, forContact: contact.id) ?? ""
        } else if newContact.photoName.isEmpty {
            let rando: Int = Int.random(in: 1...15)
            newContact.photoName = "Ghosty\(rando)"
        }
        contacts[newContact.id] = newContact
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].contactIDs.append(newContact.id)
            saveAll()
        }
        
        // Set the companyID for the new contact
        contacts[newContact.id]?.companyID = company.id
    }

    func updateContact(_ contact: Contact, with image: UIImage?) {
        var updatedContact = contact
        if let image = image {
            updatedContact.photoName = saveImage(image, forContact: contact.id) ?? contact.photoName
        }
        contacts[updatedContact.id] = updatedContact
        saveAll()
    }
    
    func deleteContact(_ contact: Contact) {
        contacts.removeValue(forKey: contact.id)
        for i in 0..<companies.count {
            companies[i].contactIDs.removeAll { $0 == contact.id }
        }
        
        // Delete the associated image
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(contact.photoName)
            try? fileManager.removeItem(at: fileURL)
        }
        
        saveAll()
    }
    
    func getImage(for contact: Contact) -> UIImage? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(contact.photoName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else if let defaultImage = UIImage(named: contact.photoName) {
            return defaultImage // Fallback to asset catalog for default images
        } else {
            return nil
        }
    }
    
    // MARK: - Note Methods
    
    func addNote(_ note: Note) {
        notes[note.id] = note
        saveAll()
    }
    
    func updateNote(_ note: Note) {
        notes[note.id] = note
        saveAll()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeValue(forKey: note.id)
        saveAll()
    }
    
    func notesForContact(_ contact: Contact) -> [Note] {
        return notes.values.filter { $0.contactID == contact.id }.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: - Order Methods
    
    func addOrder(_ order: Order, to company: Company) {
        var newOrder = order
        newOrder.companyID = company.id // Set the companyID
        orders[newOrder.id] = newOrder
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].orderIDs.append(newOrder.id)
            saveAll()
            NotificationManager.shared.scheduleNotification(for: newOrder)
        }
    }
    
    func updateOrder(_ order: Order) {
        orders[order.id] = order
        saveAll()
        NotificationManager.shared.scheduleNotification(for: order)
    }
    
    func deleteOrder(_ order: Order) {
        orders.removeValue(forKey: order.id)
        for i in 0..<companies.count {
            companies[i].orderIDs.removeAll { $0 == order.id }
        }
        saveAll()
    }
    
    // MARK: - Interaction Methods
    
    func addInteraction(_ interaction: Interaction, to company: Company) {
        var newInteraction = interaction
        newInteraction.companyID = company.id // Set the companyID
        interactions[newInteraction.id] = newInteraction
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].interactionIDs.append(newInteraction.id)
            saveAll()
        }
    }
    
    func updateInteraction(_ interaction: Interaction) {
        interactions[interaction.id] = interaction
        saveAll()
    }
    
    func deleteInteraction(_ interaction: Interaction) {
        interactions.removeValue(forKey: interaction.id)
        for i in 0..<companies.count {
            companies[i].interactionIDs.removeAll { $0 == interaction.id }
        }
        saveAll()
    }
    
    // MARK: - Task Methods
    
    func addTask(_ task: Task, to company: Company) {
        var newTask = task
        newTask.companyID = company.id // Set the companyID
        tasks[newTask.id] = newTask
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].taskIDs.append(newTask.id)
            saveAll()
            NotificationManager.shared.scheduleNotification(for: newTask)
        }
    }
    
    func updateTask(_ task: Task) {
        tasks[task.id] = task
        saveAll()
        NotificationManager.shared.scheduleNotification(for: task)
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeValue(forKey: task.id)
        for i in 0..<companies.count {
            companies[i].taskIDs.removeAll { $0 == task.id }
        }
        saveAll()
    }
    
    // MARK: - Helper Methods
    
    func contactsForCompany(_ company: Company) -> [Contact] {
        return company.contactIDs.compactMap { contacts[$0] }
    }
    
    func ordersForCompany(_ company: Company) -> [Order] {
        return company.orderIDs.compactMap { orders[$0] }
    }
    
    func interactionsForCompany(_ company: Company) -> [Interaction] {
        return company.interactionIDs.compactMap { interactions[$0] }
    }
    
    func tasksForCompany(_ company: Company) -> [Task] {
        return company.taskIDs.compactMap { tasks[$0] }
    }
    
    func companyName(for order: Order) -> String {
        guard let companyID = order.companyID,
              let company = companies.first(where: { $0.id == companyID }) else {
            return "Unknown Company"
        }
        return company.name
    }
    
    func companyName(for task: Task) -> String {
        guard let companyID = task.companyID,
              let company = companies.first(where: { $0.id == companyID }) else {
            return "Unknown Company"
        }
        return company.name
    }
    
    func companyName(for interaction: Interaction) -> String {
        guard let companyID = interaction.companyID,
              let company = companies.first(where: { $0.id == companyID }) else {
            return "Unknown Company"
        }
        return company.name
    }
    
    func companyName(for contact: Contact) -> String {
        guard let companyID = contact.companyID,
              let company = companies.first(where: { $0.id == companyID }) else {
            return "Unknown Company"
        }
        return company.name
    }
    
    func companyName(for note: Note) -> String {
        guard let companyID = note.companyID,
              let company = companies.first(where: { $0.id == companyID }) else {
            return "Unknown Company"
        }
        return company.name
    }
    // MARK: - Company Mapping
    var companyMapping: [UUID: Company] {
        Dictionary(uniqueKeysWithValues: companies.map { ($0.id, $0) })
    }
}
