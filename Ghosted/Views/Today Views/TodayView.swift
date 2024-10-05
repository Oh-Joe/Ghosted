import SwiftUI

struct TodayView: View {
    @EnvironmentObject var dataModel: DataModel
    var randoToday: Int = Int.random(in: 1...6)
    
    var body: some View {
        if companiesWithDueItems.isEmpty {
            VStack(spacing: 18) {
                Image("NothingUrgent\(randoToday)")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text((1...3).contains(randoToday) ? "It's a good time to cultivate your accounts!" : "But your boss doesn't need to know that.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .padding(.bottom, 40)
            .navigationTitle("Nothing urgent today")
        } else {
            List {
                ForEach(companiesWithDueItems, id: \.id) { company in
                    NavigationLink(destination: CompaniesHomeView(selectedTab: selectedTab(for: company), company: company)) {
                        CompanyRowView(company: company, dueItems: dueItemsForCompany(company))
                    }
                }
            }
            .navigationTitle("Today's focus")
        }
    }
    
    private var companiesWithDueItems: [Company] {
        dataModel.companies.filter { company in
            let dueItems = dueItemsForCompany(company)
            return !dueItems.orders.isEmpty || !dueItems.tasks.isEmpty
        }
    }
    
    private func dueItemsForCompany(_ company: Company) -> (orders: [Order], tasks: [Task]) {
        let today = Calendar.current.startOfDay(for: Date())
        
        let dueOrders = company.orderIDs.compactMap { dataModel.orders[$0] }
            .filter { $0.isOverdue || (Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.isFullyPaid) }
        
        let dueTasks = company.taskIDs.compactMap { dataModel.tasks[$0] }
            .filter { $0.isOverdue || (Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.isDone) }
        
        return (dueOrders, dueTasks)
    }
    
    private func selectedTab(for company: Company) -> CompaniesHomeView.Tab {
        let dueItems = dueItemsForCompany(company)
        if !dueItems.orders.isEmpty || (!dueItems.orders.isEmpty && !dueItems.tasks.isEmpty) {
            return .orders // Go to orders tab if there are due orders or both orders and tasks
        } else if !dueItems.tasks.isEmpty {
            return .tasks // Go to tasks tab if there are due tasks
        }
        return .details // Default to details tab if no due items
    }
}

struct CompanyRowView: View {
    let company: Company
    let dueItems: (orders: [Order], tasks: [Task])
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(company.name)
                .font(.headline)
            if !dueItems.orders.isEmpty {
                Text("Orders due: \(dueItems.orders.count)")
                    .font(.subheadline)
            }
            if !dueItems.tasks.isEmpty {
                Text("Tasks due: \(dueItems.tasks.count)")
                    .font(.subheadline)
            }
        }
    }
}
