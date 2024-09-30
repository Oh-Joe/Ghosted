import SwiftUI

struct CompaniesHomeView: View {
    @State private var selectedCompany: Company?
    
    var company: Company
    
    var body: some View {
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
                }
            TaskListView(company: company)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
        }
        .navigationTitle(company.name)
    }
}
