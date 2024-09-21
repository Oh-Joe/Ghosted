import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedTab: Tab = .accounts

    var randoAccounts: Int = Int.random(in: 1...5)
    var randoSalesChart: Int = Int.random(in: 1...6)
    var randoSalesDashboard: Int = Int.random(in: 1...4)

    enum Tab {
        case accounts
        case salesCharts
        case salesDashboard
        case contacts
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: AccountListView()) {
                    VStack {
                        Image("SectionImageClientAccounts\(randoAccounts)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        VStack {
                            Text("Manage your clients and leads")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Create accounts and their contacts, orders, tasks, keep track of interactions, and more.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.accounts)
                
                NavigationLink(destination: SalesChartView()) {
                    VStack {
                        Image("SectionSales\(randoSalesChart)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        VStack {
                            Text("Sales Charts")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("View account sales by month, year, or all time.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.salesCharts)
                
                NavigationLink(destination: SalesDashboardView()) {
                    VStack {
                        Image("SectionSalesDashboard\(randoSalesDashboard)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        VStack {
                            Text("Sales Dashboard")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Advanced sales analytics and shit.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.salesDashboard)
                
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .navigationTitle(pageTitle)
        }
    }
    
    // MARK: functions & helpers
    private var pageTitle: String {
        switch selectedTab {
        case .accounts:
            return "Accounts"
        case .salesCharts:
            return "Sales Charts"
        case .salesDashboard:
            return "Sales Dashboard"
        case .contacts:
            return "Contacts"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
