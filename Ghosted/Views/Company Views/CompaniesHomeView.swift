import SwiftUI

struct CompaniesHomeView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedCompany: Company?
    @State private var overdueOrderCount: Int? = nil
    @State private var overdueTaskCount: Int? = nil
    
    @State var selectedTab: Tab

        enum Tab {
            case details
            case contacts
            case interactions
            case orders
            case tasks
        }
    
    var company: Company
    
    var body: some View {
        
        let overdueOrderCount = dataModel.ordersForCompany(company).count(where: { $0.isOverdue })
            
        let overdueTaskCount = dataModel.tasksForCompany(company).count(where: { $0.isOverdue })
        
        TabView(selection: $selectedTab) {
            CompanyDetailView(company: company)
                .tabItem {
                    Label("Details", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.details)
            
            ContactListView(company: company)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
                .tag(Tab.contacts)
            
            InteractionListView(company: company)
                .tabItem {
                    Label("Interactions", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.interactions)
            
            OrderListView(company: company)
                .tabItem {
                    Label("Orders", systemImage: "dollarsign.circle.fill")
                }
                .badge(overdueOrderCount)
                .tag(Tab.orders)
            
            TaskListView(company: company)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
                .badge(overdueTaskCount)
                .tag(Tab.tasks)
        }
        .navigationTitle(company.name)
    }
}
