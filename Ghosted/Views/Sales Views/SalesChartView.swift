import SwiftUI
import Charts

struct SalesChartView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedPeriod: ChartPeriod = .month
    @State private var selectedDate: Date = Date()
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedAccounts: Set<UUID> = []
    @State private var selectedBar: UUID?
    @State private var chartUpdateTrigger = UUID()
    @State private var isShowingMonthPicker = false
    
    enum ChartPeriod: String, CaseIterable {
        case month = "Month"
        case year = "Year"
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                periodPicker
                dateSelector
                chartView
                    .frame(height: 350)
                accountFilterView
            }
            
            .navigationTitle("Sales Charts")
            .sheet(isPresented: $isShowingMonthPicker) {
                MonthYearPicker(selectedDate: $selectedDate)
                    .presentationDetents([.customHeight])
                    .presentationDragIndicator(.visible)
            }
            .onChangeCompatible(of: selectedDate) { _ in
                chartUpdateTrigger = UUID()
            }
            .onChangeCompatible(of: selectedYear) { _ in
                chartUpdateTrigger = UUID()
            }
            .onChangeCompatible(of: selectedPeriod) { _ in
                chartUpdateTrigger = UUID()
            }
            .onChangeCompatible(of: selectedAccounts) { _ in
                chartUpdateTrigger = UUID()
            }
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
    
    private var dateSelector: some View {
        HStack {
            Text(dateSelectorLabel)
                .frame(height: 30) // Set a fixed height
            
            if selectedPeriod == .month {
                Text(selectedDate, formatter: monthYearFormatter)
                    .foregroundStyle(Color.accentColor)
                    .onTapGesture { isShowingMonthPicker = true }
            } else if selectedPeriod == .year {
                Picker("", selection: $selectedYear) {
                    ForEach((2000...Calendar.current.component(.year, from: Date())), id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
            }
            Spacer()
        }
        .frame(height: 30) // Set a fixed height for the entire HStack
        .padding(.horizontal, 18)
    }
    
    private var chartView: some View {
        Group {
            if filteredSalesData.isEmpty {
                VStack {
                    Spacer()
                    Image("noData")
                        .resizable()
                        .scaledToFit()
                    Text("No data available for the selected period and account(s).")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(height: 350) // Set a frame to keep layout consistent
            } else {
                Chart(filteredSalesData) { data in
                    BarMark(
                        x: .value("Account", data.accountName),
                        y: .value("Sales", data.totalSales)
                    )
                    .foregroundStyle(data.accountId == selectedBar ? Color.accentColor : Color.secondary)
                    .annotation(position: .top) {
                        if data.accountId == selectedBar {
                            Text(data.totalSales, format: .currency(code: "USD"))
                                .font(.caption)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(orientation: .automatic)
                    }
                }
                .frame(height: 350)
                .padding()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            if let tappedBar = getBarAtLocation(point: value.location) {
                                selectedBar = (selectedBar == tappedBar) ? nil : tappedBar
                            }
                        }
                )
                .id(chartUpdateTrigger)
            }
        }
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
        
        switch selectedPeriod {
        case .month:
            return calendar.isDate(order.issuedDate, equalTo: selectedDate, toGranularity: .month)
        case .year:
            return calendar.component(.year, from: order.issuedDate) == selectedYear
        case .allTime:
            return true
        }
    }
    
    private var dateSelectorLabel: String {
        switch selectedPeriod {
        case .month: return "Select Month:"
        case .year: return "Select Year:"
        case .allTime: return "All Time"
        }
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }
    
    private func getBarAtLocation(point: CGPoint) -> UUID? {
        let barWidth = (UIScreen.main.bounds.width - 40) / CGFloat(filteredSalesData.count)
        let index = Int(point.x / barWidth)
        guard index >= 0 && index < filteredSalesData.count else { return nil }
        return filteredSalesData[index].accountId
    }
}

struct SalesData: Identifiable {
    let id = UUID()
    let accountId: UUID
    let accountName: String
    let totalSales: Double
}

extension PresentationDetent {
    static let customHeight = Self.height(250)
}

extension View {
    func onChangeCompatible<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            return onChange(of: value) { oldValue, newValue in
                action(newValue)
            }
        } else {
            return onChange(of: value, perform: action)
        }
    }
}
