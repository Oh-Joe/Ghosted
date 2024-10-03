import SwiftUI
import Charts
import UIKit

struct CompanyDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var isShowingSafariView: Bool = false
    @State private var isShowingInvalidURLAlert: Bool = false
    @State private var isShowingLastYearLineChart: Bool = false
    @State private var selectedMonth: String?
    
    var company: Company
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.secondary)
                    Text(company.status.rawValue)
                }
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.secondary)
                    Text("\(company.country.rawValue)")
                }
                HStack {
                    Image(systemName: "list.clipboard")
                        .foregroundStyle(Color.secondary)
                    Text(company.companyType.rawValue)
                }
                
                Button {
                    var urlString = company.website
                    if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                        urlString = "https://" + urlString
                    }
                    
                    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                        isShowingSafariView = true
                    } else {
                        isShowingInvalidURLAlert = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundStyle(Color.secondary)
                        Text(company.website)
                    }
                }
            } header: {
                Text("") // just for the space
            }
            
            if !company.generalNotes.isEmpty {
                Section {
                    Text(company.generalNotes)
                } header: {
                    Text("Notes")
                }
            }
            
            Section {
                HStack {
                    Toggle("Show previous year:", isOn: $isShowingLastYearLineChart)
                }
                
                salesComparisonChart
                    .frame(height: 300)

            } header: {
                Text("Sales Chart")
            }
        }
        .navigationTitle(company.name)
        .fullScreenCover(isPresented: $isShowingSafariView) {
            if let url = URL(string: "https://\(company.website)"), UIApplication.shared.canOpenURL(url) {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .alert("Invalid URL", isPresented: $isShowingInvalidURLAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The website URL appears to be invalid.")
        }
    }
    
    private var salesComparisonChart: some View {
        Chart {
            ForEach(monthlySalesData) { monthData in
                thisYearBarMark(for: monthData)
            }
            if isShowingLastYearLineChart {
                lastYearLineMark()
            }
        }
        .chartForegroundStyleScale([
            "Current Year": .green,
            "Previous Year": .pink
        ])
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                if let month = value.as(String.self) {
                    AxisValueLabel { Text(month) }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing)
        }
        .chartLegend(position: .bottom)
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(initialX: initialScrollPosition)
        .chartXVisibleDomain(length: visibleMonths)
    }
    
    private func thisYearBarMark(for monthData: CompanySalesData) -> some ChartContent {
        BarMark(
            x: .value("Month", monthData.month),
            y: .value("This Year", monthData.sales)
        )
        .foregroundStyle(Color.green)
    }
    
    private func lastYearLineMark() -> some ChartContent {
        ForEach(monthlySalesData) { monthData in
            if let lastYearSales = monthData.lastYearSales {
                LineMark(
                    x: .value("Month", monthData.month),
                    y: .value("Last Year", lastYearSales)
                )
                .foregroundStyle(Color.pink)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .symbol() {
                    Circle()
                        .fill(.pink)
                        .frame(width: 6, height: 6)
                }
                .symbolSize(45)
            }
        }
    }
    
    private var monthlySalesData: [CompanySalesData] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/yyyy"
        
        let relevantOrders = dataModel.orders.values.filter { company.orderIDs.contains($0.id) }
        guard let firstOrderDate = relevantOrders.map({ $0.issuedDate }).min() else { return [] }
        
        let startDate = calendar.startOfMonth(for: firstOrderDate)
        let endDate = Date()
        
        var currentDate = startDate
        var monthlyData: [CompanySalesData] = []
        
        while currentDate <= endDate {
            let monthSales = relevantOrders
                .filter { calendar.isDate($0.issuedDate, equalTo: currentDate, toGranularity: .month) }
                .reduce(0) { $0 + $1.orderAmount }
            
            let lastYearDate = calendar.date(byAdding: .year, value: -1, to: currentDate)!
            let lastYearSales = relevantOrders
                .filter { calendar.isDate($0.issuedDate, equalTo: lastYearDate, toGranularity: .month) }
                .reduce(0) { $0 + $1.orderAmount }
            
            monthlyData.append(CompanySalesData(
                month: dateFormatter.string(from: currentDate),
                sales: monthSales,
                lastYearSales: lastYearSales > 0 ? lastYearSales : nil
            ))
            
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        return monthlyData
    }
    
    private var initialScrollPosition: String {
        return monthlySalesData.last?.month ?? monthlySalesData.first?.month ?? ""
    }
    
    private var visibleMonths: Int {
        // Check if the device is an iPad
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 6 // Use 6 for iPhone
        } else {
            return 12 // Use 12 for other devices
        }
    }
}

struct CompanySalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
    let lastYearSales: Double?
}
