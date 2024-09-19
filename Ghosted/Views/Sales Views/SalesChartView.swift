import SwiftUI
import Charts

struct SalesChartView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedPeriod: ChartPeriod = .month
    @State private var selectedMonth: Date = Date()
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedAccounts: Set<UUID> = []
    @State private var selectedBar: UUID?
    
    enum ChartPeriod: String, CaseIterable {
        case month = "Month"
        case year = "Year"
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                periodPicker
                
                VStack {
                    if selectedPeriod != .allTime {
                        if selectedPeriod == .month {
                            monthPicker
                        } else {
                            yearPicker
                        }
                    } else {
                        // Placeholder view to maintain spacing
                        Color.clear
                    }
                }
                .frame(height: 50) // Adjust this height to match your pickers
                
                ScrollView(.horizontal, showsIndicators: false) {
                    chartView
                        .frame(width: max(UIScreen.main.bounds.width, CGFloat(filteredSalesData.count) * 60))
                }
                
                accountFilterView
            }
            .navigationTitle("Sales Chart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var periodPicker: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(ChartPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var monthPicker: some View {
        DatePicker("Select Month", selection: $selectedMonth, displayedComponents: [.date])
            .datePickerStyle(CompactDatePickerStyle())
            .padding()
    }
    
    private var yearPicker: some View {
        HStack {
            Text("Select Year")
                .padding(.leading) // This will use the default padding, matching the DatePicker
            Spacer()
            Picker("Select Year", selection: $selectedYear) {
                ForEach((2020...Calendar.current.component(.year, from: Date())), id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.trailing) // Add trailing padding to match the DatePicker
        }
        .padding(.vertical) // Add vertical padding to match the DatePicker's overall padding
    }
    
    private var chartView: some View {
        Chart(filteredSalesData) { data in
            BarMark(
                x: .value("Account", data.accountName),
                y: .value("Sales", data.totalSales)
            )
            .foregroundStyle(data.accountId == selectedBar ? .accent : .secondary)
            .annotation(position: .top) {
                if data.accountId == selectedBar {
                    Text(data.totalSales, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel(orientation: .automatic)
            }
        }
        .frame(height: 300)
        .padding()
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    if let tappedBar = getBarAtLocation(point: value.location) {
                        selectedBar = (selectedBar == tappedBar) ? nil : tappedBar
                    }
                }
        )
    }
    private func getBarAtLocation(point: CGPoint) -> UUID? {
        let chartWidth = UIScreen.main.bounds.width - 32 // Assuming 16pt padding on each side
        let barWidth = chartWidth / CGFloat(filteredSalesData.count)
        let index = Int(point.x / barWidth)
        guard index >= 0 && index < filteredSalesData.count else { return nil }
        return filteredSalesData[index].accountId
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
        
        let data = filteredAccounts.compactMap { account in
            let totalSales = account.orders
                .filter { isOrderInSelectedPeriod($0) }
                .reduce(0) { $0 + $1.orderAmount }
            
            return totalSales > 0 ? SalesData(accountId: account.id, accountName: account.name, totalSales: totalSales) : nil
        }
        
        return data.sorted { $0.totalSales > $1.totalSales }
    }
    
    private func isOrderInSelectedPeriod(_ order: Order) -> Bool {
        let calendar = Calendar.current
        
        switch selectedPeriod {
        case .allTime:
            return true
        case .month:
            return calendar.isDate(order.issuedDate, equalTo: selectedMonth, toGranularity: .month)
        case .year:
            return calendar.component(.year, from: order.issuedDate) == selectedYear
        }
    }
}

struct SalesData: Identifiable {
    let id = UUID()
    let accountId: UUID
    let accountName: String
    let totalSales: Double
}
