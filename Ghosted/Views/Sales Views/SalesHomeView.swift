//
//  SalesHomeView.swift
//  Ghosted
//
//  Created by Ackuretta on 2024/9/20.
//

import SwiftUI

struct SalesHomeView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedTab: Tab = .salesChart
    
    enum Tab {
        case salesChart
        case salesDashboard
    }
    
    let randoSalesChart: Int = Int.random(in: 1...6)
    let randoSalesDashboard: Int = Int.random(in: 1...6)
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: SalesChartView()) {
                    VStack {
                        Image("SectionSales\(randoSalesChart)")
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
                
                NavigationLink(destination: SalesDashboardView()) {
                    VStack {
                        Image("SectionSales\(randoSalesDashboard)")
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
                .tag(Tab.salesDashboard)
            }
        }
    }
}

#Preview {
    SalesHomeView()
}
