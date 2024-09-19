import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedTab: Tab = .accounts

    var randoAccounts: Int = Int.random(in: 1...5)
    var randoSales: Int = Int.random(in: 1...6)

    enum Tab {
        case accounts
        case salesChart
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
                        Text("View your clients and leads.")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.accounts)

                NavigationLink(destination: SalesChartView()) {
                    VStack {
                        Image("SectionSales\(randoSales)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        Text("View sales charts and analytics.")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.salesChart)

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
        case .salesChart:
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
