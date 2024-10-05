import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var scrollPosition: String?
    @State private var selectedMonth: String?
    @State private var monthsPerScreen: Int = {
        // Set the default value based on the device type
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 6 // Default for iPhone
        } else {
            return 12 // Default for iPad
        }
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Months displayed: \(monthsPerScreen)")
                HStack {
                    Stepper("", value: $monthsPerScreen, in: 1...12)
                    .fixedSize()
                    Spacer()
                }
                .padding(.horizontal, -8)
            }
            .padding(.horizontal)
            Spacer()
            chartView
                .padding()
            
            Spacer()
            
            if let selectedMonth = selectedMonth,
               let monthData = monthlySalesData.first(where: { $0.monthYear == selectedMonth }) {
                selectedMonthView(monthData: monthData)
            }
        }
        .navigationTitle("Monthly Sales")
    }
    
    private var chartView: some View {
        let companyColors = generateColors(for: dataModel.companies.count)
        
        return Chart(monthlySalesData) { monthData in
            ForEach(dataModel.companies) { company in
                BarMark(
                    x: .value("Month", monthData.monthYear),
                    y: .value("Sales", monthData.salesByCompany[company.id] ?? 0)
                )
                .foregroundStyle(by: .value("Company", company.name))
            }
        }
        .chartForegroundStyleScale(range: companyColors)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                if let monthYear = value.as(String.self) {
                    AxisValueLabel { Text(monthYear) }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing)
        }
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(initialX: initialScrollPosition)
        .chartXVisibleDomain(length: monthsPerScreen)
        .chartLegend(position: .bottom, alignment: .leading)
    }
    
    private func selectedMonthView(monthData: MonthlySalesData) -> some View {
        VStack(alignment: .leading) {
            Text("Selected Month: \(monthData.monthYear)")
                .font(.headline)
            ForEach(dataModel.companies) { company in
                Text("\(company.name): $\(monthData.salesByCompany[company.id] ?? 0, specifier: "%.2f")")
            }
        }
        .padding()
    }
    
    private var monthlySalesData: [MonthlySalesData] {
        let allOrders = dataModel.orders.values.sorted(by: { $0.issuedDate < $1.issuedDate })
        
        guard let firstDate = allOrders.first?.issuedDate else { return [] }
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/yyyy"
        
        var currentDate = calendar.startOfMonth(for: firstDate)
        let endDate = Date() // Use today as the end date
        
        var monthlySales: [MonthlySalesData] = []
        
        while currentDate <= endDate {
            let monthYear = dateFormatter.string(from: currentDate)
            var salesByCompany: [UUID: Double] = [:]
            
            for company in dataModel.companies {
                let companyOrders = allOrders.filter { order in
//                    company.orderIDs.contains(order.id) && // for old data structure with single-way linking where Company has a [orderID] but Order doesn't have a companyID property.
                    order.companyID == company.id && // new structure where Order has a companyID property
                    calendar.isDate(order.issuedDate, equalTo: currentDate, toGranularity: .month)
                }
                let totalAmount = companyOrders.reduce(0) { $0 + $1.orderAmount }
                salesByCompany[company.id] = totalAmount
            }
            
            monthlySales.append(MonthlySalesData(monthYear: monthYear, salesByCompany: salesByCompany))
            
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        return monthlySales
    }
    
    private var initialScrollPosition: String {
        return monthlySalesData.last?.monthYear ?? monthlySalesData.first?.monthYear ?? ""
    }
    
    private func generateColors(for count: Int) -> [Color] {
        let baseColors: [Color] = [.blue, .green, .orange, .purple, .red]
        guard count > 0 else { return [] }
        
        if count <= baseColors.count {
            return Array(baseColors.prefix(count))
        } else {
            return (0..<count).map { index in
                let hue = Double(index) / Double(count)
                return Color(hue: hue, saturation: 0.7, brightness: 0.9)
            }
        }
    }
}

struct MonthlySalesData: Identifiable {
    let id = UUID()
    let monthYear: String
    let salesByCompany: [UUID: Double]
}

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}
