import SwiftUI

struct CompaniesHomeView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedCompany: Company?
    @State private var overdueOrderCount: Int? = nil
    @State private var overdueTaskCount: Int? = nil
    
    var company: Company
    
    var body: some View {
        
        let overdueOrderCount = dataModel.ordersForCompany(company).count(where: { $0.isOverdue })
            
        let overdueTaskCount = dataModel.tasksForCompany(company).count(where: { $0.isOverdue })
        
        TabView {
            CompanyDetailView(company: company)
                .tabItem {
                    Label("Details", systemImage: "list.bullet.clipboard")
                }
            
            ContactListView(company: company)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
            
            InteractionListView(company: company)
                .tabItem {
                    Label("Interactions", systemImage: "bubble.left.and.bubble.right.fill")
                }
            
            OrderListView(company: company)
                .tabItem {
                    Label("Orders", systemImage: "dollarsign.circle.fill")
                }.badge(overdueOrderCount)
            
            TaskListView(company: company)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }.badge(overdueTaskCount)
        }
        .navigationTitle(company.name)
    }
}
