import SwiftUI
import Charts

struct SalesDashboardView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedDateRange: DateRange = .lastMonth
    @State private var selectedCurrency: Order.Currency?
    @State private var showOnlyUnpaidOrders: Bool = false
    @State private var customStartDate: Date = Date().addingTimeInterval(-30*24*60*60)
    @State private var customEndDate: Date = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                filterControls
                
                Divider()
                keyMetricsView
                
                Divider()
                Text("Revenue over time")
                    .font(.title3)
                    .padding(.top, 8)
                revenueOverTimeChart
                
                Divider()
                Text("Paid/Unpaid Orders")
                    .font(.title3)
                    .padding(.top, 8)
                paymentStatusChart
                
                Divider()
                currencyDistributionChart
                
                Divider()
                Text("Orders due")
                    .font(.title3)
                    .padding(.top, 8)
                outstandingPaymentsTimeline
                
                Divider()
                topOrdersTable
                
                Divider()
                monthlyRevenueHeatmap
                
                Divider()
                orderFulfillmentFunnel
            }
            .padding()
        }
        .navigationTitle("Sales Dashboard")
    }
    
    private var filterControls: some View {
        VStack {
            Picker("Date Range", selection: $selectedDateRange) {
                Text("Last Week").tag(DateRange.lastWeek)
                Text("Last Month").tag(DateRange.lastMonth)
                Text("Last Quarter").tag(DateRange.lastQuarter)
                Text("Last Year").tag(DateRange.lastYear)
                Text("Custom").tag(DateRange.custom(customStartDate, customEndDate))
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if case .custom = selectedDateRange {
                HStack {
                    DatePicker("Start", selection: $customStartDate, displayedComponents: .date)
                    DatePicker("End", selection: $customEndDate, displayedComponents: .date)
                }
            }
            
            currencyPicker
            
            Toggle("Show Only Unpaid Orders", isOn: $showOnlyUnpaidOrders)
        }
    }
    
    private var currencyPicker: some View {
        let currencies = Array(Set(dataModel.orders.values.map { $0.currency }))
        return Picker("Currency", selection: $selectedCurrency) {
            Text("All").tag(nil as Order.Currency?)
            ForEach(currencies, id: \.self) { currency in
                Text(currency.rawValue).tag(currency as Order.Currency?)
            }
        }
    }
    
    private var keyMetricsView: some View {
        HStack {
            MetricCard(title: "Total Revenue", value: totalRevenue, format: "$%.2f")
            MetricCard(title: "Average Order Value", value: averageOrderValue, format: "$%.2f")
            MetricCard(title: "Number of Orders", value: Double(filteredOrders.count), format: "%.0f")
            MetricCard(title: "% Paid Orders", value: percentagePaidOrders, format: "%.1f%%")
        }
    }
    
    private var revenueOverTimeChart: some View {
        Chart {
            ForEach(groupedOrdersByDate, id: \.key) { date, orders in
                LineMark(
                    x: .value("Date", date),
                    y: .value("Revenue", orders.reduce(0) { $0 + $1.orderAmount })
                )
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .frame(height: 300)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
    
    private var paymentStatusChart: some View {
        Chart {
            SectorMark(
                angle: .value("Paid", paidOrdersCount),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(.green)
            
            SectorMark(
                angle: .value("Unpaid", unpaidOrdersCount),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(.red)
        }
        .frame(height: 300)
    }
    
    private var currencyDistributionChart: some View {
        Chart(currencyDistribution, id: \.currency) { item in
            SectorMark(
                angle: .value("Value", item.value),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(by: .value("Currency", item.currency.rawValue))
        }
        .frame(height: 300)
    }
    
    private var outstandingPaymentsTimeline: some View {
        Chart {
            ForEach(Array(unpaidOrders.enumerated()), id: \.element.id) { index, order in
                BarMark(
                    xStart: .value("Issue Date", order.issuedDate),
                    xEnd: .value("Due Date", order.dueDate),
                    y: .value("Order", order.orderNumber)
                )
            }
        }
        .frame(height: 300)
    }
    
    private var topOrdersTable: some View {
        VStack(alignment: .leading) {
            Text("Top Orders")
                .font(.title3)
                .padding(.top, 8)
            
            ForEach(Array(filteredOrders.sorted { $0.orderAmount > $1.orderAmount }.prefix(5).enumerated()), id: \.element.id) { index, order in
                HStack {
                    Text("\(index + 1)")
                        .frame(width: 20, alignment: .leading)
                    Text(order.orderNumber)
                    Spacer()
                    Text(String(format: "%.2f", order.orderAmount))
                    Text(order.currency.rawValue)
                    Text(order.issuedDate, style: .date)
                    Text(order.isFullyPaid ? "Paid" : "Unpaid")
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var monthlyRevenueHeatmap: some View {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 1, day: 1))!
        let endDate = Date()
        let dates = calendar.generateDates(inside: DateInterval(start: startDate, end: endDate), matching: DateComponents(hour: 0, minute: 0, second: 0))
        
        return VStack(alignment: .leading) {
            Text("Monthly Revenue Heatmap")
                .font(.title3)
                .padding(.top, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                ForEach(dates.indices, id: \.self) { index in
                    let date = dates[index]
                    let revenue = dailyRevenue(for: date)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(colorForRevenue(revenue))
                        .frame(height: 20)
                        .overlay(
                            Text(calendar.isDate(date, equalTo: Date(), toGranularity: .month) ? String(calendar.component(.day, from: date)) : "")
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
    
    private var orderFulfillmentFunnel: some View {
        Chart {
            BarMark(
                x: .value("Stage", "Issued"),
                y: .value("Count", Double(filteredOrders.count))
            )
            BarMark(
                x: .value("Stage", "Paid"),
                y: .value("Count", Double(paidOrdersCount))
            )
        }
        .chartYScale(domain: 0...Double(filteredOrders.count))
        .frame(height: 300)
    }
    
    // MARK: - Helper computed properties
    
    private var filteredOrders: [Order] {
        dataModel.orders.values.filter { order in
            let dateFilter: Bool
            switch selectedDateRange {
            case .lastWeek:
                dateFilter = order.issuedDate > Date().addingTimeInterval(-7*24*60*60)
            case .lastMonth:
                dateFilter = order.issuedDate > Date().addingTimeInterval(-30*24*60*60)
            case .lastQuarter:
                dateFilter = order.issuedDate > Date().addingTimeInterval(-90*24*60*60)
            case .lastYear:
                dateFilter = order.issuedDate > Date().addingTimeInterval(-365*24*60*60)
            case .custom(let start, let end):
                dateFilter = order.issuedDate >= start && order.issuedDate <= end
            }
            
            let currencyFilter = selectedCurrency == nil || order.currency == selectedCurrency
            let paymentFilter = !showOnlyUnpaidOrders || !order.isFullyPaid
            
            return dateFilter && currencyFilter && paymentFilter
        }
    }
    
    private var totalRevenue: Double {
        filteredOrders.reduce(0) { $0 + $1.orderAmount }
    }
    
    private var averageOrderValue: Double {
        filteredOrders.isEmpty ? 0 : totalRevenue / Double(filteredOrders.count)
    }
    
    private var percentagePaidOrders: Double {
        filteredOrders.isEmpty ? 0 : (Double(paidOrdersCount) / Double(filteredOrders.count)) * 100
    }
    
    private var paidOrdersCount: Int {
        filteredOrders.filter { $0.isFullyPaid }.count
    }
    
    private var unpaidOrdersCount: Int {
        filteredOrders.count - paidOrdersCount
    }
    
    private var groupedOrdersByDate: [(key: Date, value: [Order])] {
        Dictionary(grouping: filteredOrders) { order in
            Calendar.current.startOfDay(for: order.issuedDate)
        }.sorted { $0.key < $1.key }
    }
    
    private var currencyDistribution: [(currency: Order.Currency, value: Double)] {
        Dictionary(grouping: filteredOrders) { $0.currency }
            .mapValues { orders in orders.reduce(0) { $0 + $1.orderAmount } }
            .map { (currency: $0, value: $1) }
            .sorted { $0.value > $1.value }
    }
    
    private var unpaidOrders: [Order] {
        filteredOrders.filter { !$0.isFullyPaid }
    }
    
    private func dailyRevenue(for date: Date) -> Double {
        filteredOrders
            .filter { Calendar.current.isDate($0.issuedDate, inSameDayAs: date) }
            .reduce(0) { $0 + $1.orderAmount }
    }
    
    private func colorForRevenue(_ revenue: Double) -> Color {
        let maxRevenue = filteredOrders.map { $0.orderAmount }.max() ?? 0
        let normalizedRevenue = revenue / maxRevenue
        return Color(red: 0, green: 0, blue: 1, opacity: normalizedRevenue)
    }
}

struct MetricCard: View {
    let title: String
    let value: Double
    let format: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
            Text(String(format: format, value))
                .font(.headline)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.1)))
    }
}

enum DateRange: Hashable {
    case lastWeek, lastMonth, lastQuarter, lastYear, custom(Date, Date)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .lastWeek: hasher.combine(0)
        case .lastMonth: hasher.combine(1)
        case .lastQuarter: hasher.combine(2)
        case .lastYear: hasher.combine(3)
        case .custom(let start, let end):
            hasher.combine(4)
            hasher.combine(start)
            hasher.combine(end)
        }
    }
}

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}
