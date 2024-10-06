import SwiftUI

struct CompaniesHomeView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedCompany: Company?
    
    @State var selectedTab: Tab

    enum Tab {
        case details
        case orders
        case tasks
        case interactions
        case contacts
    }
    
    var company: Company
    
    var body: some View {
        // Calculate overdue counts
        let overdueOrderCount = dataModel.ordersForCompany(company).filter { $0.isOverdue }.count
        let overdueTaskCount = dataModel.tasksForCompany(company).filter { $0.isOverdue }.count
        
        // Update the app badge count
        let totalOverdueCount = dataModel.companies.reduce(0) { total, company in
            total + dataModel.ordersForCompany(company).filter { $0.isOverdue }.count +
            dataModel.tasksForCompany(company).filter { $0.isOverdue }.count
        }
        
        NotificationManager.shared.updateAppBadgeCount(to: totalOverdueCount)

        return TabView(selection: $selectedTab) { // Ensure to return the TabView
            CompanyDetailView(company: company)
                .tabItem {
                    Label("Details", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.details)
            
            OrderListView(company: company)
                .tabItem {
                    Label("Orders", systemImage: "dollarsign.circle.fill")
                }
                .badge(overdueOrderCount) // Show badge if overdue orders exist
                .tag(Tab.orders)
            
            TaskListView(company: company)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
                .badge(overdueTaskCount) // Show badge if overdue tasks exist
                .tag(Tab.tasks)
            
            InteractionListView(company: company)
                .tabItem {
                    Label("Interactions", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.interactions)
            
            ContactListView(company: company)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
                .tag(Tab.contacts)
            
        }
        .navigationTitle(company.name)
    }
}
