import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedTab: Tab = .accounts

    var randoAccounts: Int = Int.random(in: 1...5)
    var randoSalesChart: Int = Int.random(in: 1...3)
    var randoSalesDashboard: Int = Int.random(in: 4...6)

    enum Tab {
        case accounts
        case sales
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
                            Text("Manage your clients and leads.")
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
                VStack {
                    HStack {
                        NavigationLink(destination: SalesChartView()) {
                            VStack {
                                Image("SectionSales\(randoSalesChart)")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text("Bar Chart")
                                
                                
                            }
                        }
                        
                        NavigationLink(destination: SalesDashboardView()) {
                            VStack {
                                Image("SectionSales\(randoSalesDashboard)")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text("Dashboard")
                                
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Sales charts and shit.")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Get a bird's eye view of your sales by account over months, years, or all time.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }
                    Spacer()
                }
                .padding()
                .tag(Tab.sales)
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
        case .sales:
            return "Sales"
        case .contacts:
            return "Contacts"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
