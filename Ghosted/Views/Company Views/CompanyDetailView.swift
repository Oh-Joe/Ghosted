import SwiftUI
import Charts

struct CompanyDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    
    @State private var isShowingSafariView: Bool = false
    @State private var isShowingInvalidURLAlert: Bool = false
    @State private var isShowingLastYearLineChart: Bool = false
    
    
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
                    .padding()
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
            AxisMarks(position: .leading)
        }
        .chartLegend(position: .bottom)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 12)
    }
    
    private func thisYearBarMark(for monthData: CompanySalesData) -> some ChartContent {
        BarMark(
            x: .value("Month", monthData.month),
            y: .value("This Year", monthData.thisYearSales)
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
                        .frame (width: 6, height: 6)
                }
                .symbolSize (45)
                
                //                PointMark(
                //                    x: .value("Month", monthData.month),
                //                    y: .value("Last Year", lastYearSales)
                //                )
                //                .foregroundStyle(Color.red)
                //                .symbolSize(30)
            }
        }
    }
    
    private var monthlySalesData: [CompanySalesData] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let now = Date()
        let startOfThisYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        let startOfLastYear = calendar.date(byAdding: .year, value: -1, to: startOfThisYear)!
        
        let relevantOrders = dataModel.orders.values.filter { order in
            company.orderIDs.contains(order.id) && order.issuedDate >= startOfLastYear
        }
        
        var monthlyData: [CompanySalesData] = []
        
        for month in 0..<12 {
            let currentMonthThisYear = calendar.date(byAdding: .month, value: month, to: startOfThisYear)!
            let currentMonthLastYear = calendar.date(byAdding: .month, value: month, to: startOfLastYear)!
            
            let thisYearSales = relevantOrders
                .filter { calendar.isDate($0.issuedDate, equalTo: currentMonthThisYear, toGranularity: .month) }
                .reduce(0) { $0 + $1.orderAmount }
            
            let lastYearSales = relevantOrders
                .filter { calendar.isDate($0.issuedDate, equalTo: currentMonthLastYear, toGranularity: .month) }
                .reduce(0) { $0 + $1.orderAmount }
            
            monthlyData.append(CompanySalesData(
                month: dateFormatter.string(from: currentMonthThisYear),
                thisYearSales: thisYearSales,
                lastYearSales: lastYearSales > 0 ? lastYearSales : nil
            ))
        }
        
        return monthlyData
    }
}

struct CompanySalesData: Identifiable {
    let id = UUID()
    let month: String
    let thisYearSales: Double
    let lastYearSales: Double?
}
