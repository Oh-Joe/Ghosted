import SwiftUI

struct Home: View {
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var authManager: AuthManager // AuthManager handles login state
    @State private var selectedTab: Tab = .companies

    var randoToday: Int = Int.random(in: 1...3)
    var randoCompanies: Int = Int.random(in: 1...6)
    var randoSalesDashboard: Int = Int.random(in: 1...4)

    enum Tab {
        case companies
        case salesCharts
        case salesDashboard
        case contacts
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        NavigationLink(destination: TodayView()) {
                            ZStack(alignment: .bottomLeading) {
                                Image("SectionToday\(randoToday)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3.3)

                                VStack(alignment: .leading) {
                                    Text("Today")
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("Quickly view what needs to be done today.")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black.opacity(0.5))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        NavigationLink(destination: CompanyListView()) {
                            ZStack(alignment: .bottomLeading) {
                                Image("SectionCompanies\(randoCompanies)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3.3)

                                VStack(alignment: .leading) {
                                    Text("Accounts")
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("Create and manage accounts, their contacts, and orders;\ncontrol your tasks and interactions with them.")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black.opacity(0.5))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        NavigationLink(destination: ChartsView()) {
                            ZStack(alignment: .bottomLeading) {
                                Image("SectionSalesDashboard\(randoSalesDashboard)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3.3)

                                VStack(alignment: .leading) {
                                    Text("Sales Charts & Reports")
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text("View sales graphs, see and export a weekly/monthly report.")
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black.opacity(0.5))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .foregroundStyle(Color.primary)
            .padding()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            withAnimation {
                                authManager.signOut() // Sign out the user using AuthManager
                            }
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                        }
                    } label: {
                        Label("Account", systemImage: "person.circle")
                    }
                }
            }
        }
    }
}
