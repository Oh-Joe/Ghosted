import Foundation

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
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        companiesFilePath = documentsDirectory.appendingPathComponent("companies.json")
        contactsFilePath = documentsDirectory.appendingPathComponent("contacts.json")
        ordersFilePath = documentsDirectory.appendingPathComponent("orders.json")
        interactionsFilePath = documentsDirectory.appendingPathComponent("interactions.json")
        tasksFilePath = documentsDirectory.appendingPathComponent("tasks.json")
        
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
    }
    
    private func saveAll() {
        saveJSON(companies, to: companiesFilePath)
        saveJSON(Array(contacts.values), to: contactsFilePath)
        saveJSON(Array(orders.values), to: ordersFilePath)
        saveJSON(Array(interactions.values), to: interactionsFilePath)
        saveJSON(Array(tasks.values), to: tasksFilePath)
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
        companies.removeAll { $0.id == company.id }
        saveAll()
    }
    
    // MARK: - Contact Methods
    
    func addContact(_ contact: Contact, to company: Company) {
        contacts[contact.id] = contact
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].contactIDs.append(contact.id)
            saveAll()
        }
    }
    
    func updateContact(_ contact: Contact) {
        contacts[contact.id] = contact
        saveAll()
    }
    
    func deleteContact(_ contact: Contact) {
        contacts.removeValue(forKey: contact.id)
        for i in 0..<companies.count {
            companies[i].contactIDs.removeAll { $0 == contact.id }
        }
        saveAll()
    }
    
    // MARK: - Order Methods
    
    func addOrder(_ order: Order, to company: Company) {
        orders[order.id] = order
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].orderIDs.append(order.id)
            saveAll()
            NotificationManager.shared.scheduleNotification(for: order)
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
        interactions[interaction.id] = interaction
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].interactionIDs.append(interaction.id)
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
        tasks[task.id] = task
        if let index = companies.firstIndex(where: { $0.id == company.id }) {
            companies[index].taskIDs.append(task.id)
            saveAll()
            NotificationManager.shared.scheduleNotification(for: task)
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
}
