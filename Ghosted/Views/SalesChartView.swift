import SwiftUI
import Charts

struct SalesChartView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedPeriod: ChartPeriod = .currentMonth
    @State private var selectedAccounts: Set<UUID> = []
    
    enum ChartPeriod: String, CaseIterable {
        case currentMonth = "Current Month"
        case currentYear = "Current Year"
        case customYear = "Custom Year"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                chartView
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(ChartPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                accountFilterView
            }
            .navigationTitle("Sales Chart")
        }
    }
    
    private var chartView: some View {
        Chart(filteredSalesData) { data in
            BarMark(
                x: .value("Account", data.accountName),
                y: .value("Sales", data.totalSales)
            )
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel(orientation: .vertical)
            }
        }
        .frame(height: 300)
        .padding()
    }
    
    private var accountFilterView: some View {
        List {
            ForEach(modelData.accounts) { account in
                Toggle(isOn: Binding(
                    get: { selectedAccounts.contains(account.id) },
                    set: { isSelected in
                        if isSelected {
                            selectedAccounts.insert(account.id)
                        } else {
                            selectedAccounts.remove(account.id)
                        }
                    }
                )) {
                    Text(account.name)
                }
            }
        }
    }
    
    private var filteredSalesData: [SalesData] {
        let filteredAccounts = selectedAccounts.isEmpty ? modelData.accounts : modelData.accounts.filter { selectedAccounts.contains($0.id) }
        
        return filteredAccounts.compactMap { account in
            let totalSales = account.orders
                .filter { isOrderInSelectedPeriod($0) }
                .reduce(0) { $0 + $1.orderAmount }
            
            return totalSales > 0 ? SalesData(accountId: account.id, accountName: account.name, totalSales: totalSales) : nil
        }
    }
    
    private func isOrderInSelectedPeriod(_ order: Order) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .currentMonth:
            return calendar.isDate(order.issuedDate, equalTo: now, toGranularity: .month)
        case .currentYear:
            return calendar.isDate(order.issuedDate, equalTo: now, toGranularity: .year)
        case .customYear:
            // Implement custom year logic here
            return true
        }
    }
}

struct SalesData: Identifiable {
    let id = UUID()
    let accountId: UUID
    let accountName: String
    let totalSales: Double
}
