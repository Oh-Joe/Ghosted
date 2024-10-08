import SwiftUI
import PDFKit

struct SalesReportView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPeriod: Period = .currentWeek
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    // State variables for tracking user selections
    @State private var hasSelectedStartDate: Bool = false
    @State private var hasSelectedEndDate: Bool = false
    
    // State variable for sharing
    @State private var showShareSheet: Bool = false
    @State private var pdfData: Data? = nil
    
    var body: some View {
        NavigationStack {
            // Segmented Picker for Period Selection
            Picker("Select Period", selection: $selectedPeriod) {
                Text("Current Week").tag(Period.currentWeek)
                Text("Current Month").tag(Period.currentMonth)
                Text("Custom").tag(Period.custom)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Date Pickers for Custom Range
            if selectedPeriod == .custom {
                VStack(spacing: 50) {
                    HStack {
                        DatePicker("From:", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(.horizontal)
                            .onChange(of: startDate) { oldValue, newValue in
                                hasSelectedStartDate = true
                            }
                        
                        DatePicker("To:", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(.horizontal)
                            .onChange(of: endDate) { oldValue, newValue in
                                hasSelectedEndDate = true
                            }
                    }
                    
                    if hasSelectedStartDate && hasSelectedEndDate && startDate > endDate {
                        let randoError: Int = Int.random(in: 1...3)
                        VStack(spacing: 20) {
                            Image("error\(randoError)")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text("Oh no!")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Your start date is after your end date...\nBad things happen when you do that!")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
            // Display Orders
            List {
                // Orders Issued Section
                if !filteredOrders().ordersIssued.isEmpty {
                    Section {
                        ForEach(filteredOrders().ordersIssued.sorted(by: {
                            let companyName1 = dataModel.companyName(for: $0)
                            let companyName2 = dataModel.companyName(for: $1)
                            return companyName1 < companyName2 // Sort by company name
                        })) { order in
                            let companyName = dataModel.companyName(for: order)
                            SalesOrderRowView(order: order, companyName: companyName)
                        }
                    } header: {
                        Text("New Orders \(selectedPeriod.periodName(startDate: startDate, endDate: endDate)): \(formattedTotalIssuedAmount())")
                    }
                }
                
                // Orders Due Section
                if !filteredOrders().ordersDue.isEmpty {
                    Section {
                        ForEach(filteredOrders().ordersDue.sorted(by: {
                            let companyName1 = dataModel.companyName(for: $0)
                            let companyName2 = dataModel.companyName(for: $1)
                            return companyName1 < companyName2 // Sort by company name
                        })) { order in
                            let companyName = dataModel.companyName(for: order)
                            SalesOrderRowView(order: order, companyName: companyName)
                        }
                    } header: {
                        Text("Orders Due \(selectedPeriod.periodName(startDate: startDate, endDate: endDate)): \(formattedTotalExpectedAmount())")
                    }
                }
                
                // Orders Paid Section
                if !filteredOrders().ordersPaid.isEmpty {
                    Section {
                        ForEach(filteredOrders().ordersPaid.sorted(by: {
                            let companyName1 = dataModel.companyName(for: $0)
                            let companyName2 = dataModel.companyName(for: $1)
                            return companyName1 < companyName2 // Sort by company name
                        })) { order in
                            let companyName = dataModel.companyName(for: order)
                            SalesOrderRowView(order: order, companyName: companyName)
                        }
                    } header: {
                        Text("Orders Paid \(selectedPeriod.periodName(startDate: startDate, endDate: endDate)): \(formattedTotalPaidAmount())")
                    }
                }
            }
            .onChange(of: selectedPeriod) { oldValue, newValue in
                if newValue != .custom {
                    startDate = Date()
                    endDate = Date()
                    hasSelectedStartDate = false
                    hasSelectedEndDate = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Sales Report")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        createPDF() // Generate PDF when button is tapped
//                    } label: {
//                        Image(systemName: "square.and.arrow.up")
//                    }
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .presentationDragIndicator(.visible)
            .sheet(isPresented: $showShareSheet) {
                if let pdfData = pdfData {
                    ShareSheet(activityItems: [pdfData])
                }
            }
        }
    }
    
//    private func createPDF() {
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4 size
//        pdfData = pdfRenderer.pdfData { context in
//            context.beginPage()
//
//            // Example of rendering only the list or static text into the PDF
//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 595, height: 842))
//            let renderedImage = renderer.image { ctx in
//                let customView = CustomPDFContentView(startDate: startDate, endDate: endDate, dataModel: dataModel) // Simplified view for PDF
//                let hostingController = UIHostingController(rootView: customView)
//                hostingController.view.bounds = CGRect(x: 0, y: 0, width: 595, height: 842)
//                hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
//            }
//            
//            renderedImage.draw(at: .zero)
//        }
//        
//        showShareSheet = true // Present the share sheet
//    }
//
//    // Define a simpler view that renders into the PDF context
//    struct CustomPDFContentView: View {
//        let startDate: Date
//        let endDate: Date
//        let dataModel: DataModel
//
//        var body: some View {
//            VStack {
//                Text("Sales Report from \(startDate, formatter: dateFormatter) to \(endDate, formatter: dateFormatter)")
//                    .font(.headline)
//                List {
//                    ForEach(Array(dataModel.orders.values)) { order in
//                        Text("Order ID: \(order.id)")
//                    }
//                }
//            }
//            .padding()
//        }
//
//        private var dateFormatter: DateFormatter {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            return formatter
//        }
//    }

    struct OrdersIssuedDuePaid {
        let ordersIssued: [Order]
        let ordersDue: [Order]
        let ordersPaid: [Order]
    }
    
    private func filteredOrders() -> OrdersIssuedDuePaid {
        let orders = Array(dataModel.orders.values)
        let calendar = Calendar.current
        
        let start: Date
        let end: Date
        
        switch selectedPeriod {
        case .currentWeek:
            start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            end = calendar.date(byAdding: .day, value: 6, to: start)!
        case .currentMonth:
            start = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
            end = calendar.date(byAdding: .month, value: 1, to: start)!
        case .custom:
            start = startDate
            end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        }
        
        return OrdersIssuedDuePaid(
            ordersIssued: orders.filter { $0.issuedDate >= start && $0.issuedDate <= end },
            ordersDue: orders.filter { $0.dueDate >= start && $0.dueDate <= end && !$0.isFullyPaid },
            ordersPaid: orders.filter {
                $0.isFullyPaid &&
                ($0.paidDate.map { $0 >= start && $0 <= end } ?? false) // Use map to check paidDate
            }
        )
    }
    
    private func totalIssuedAmount() -> Double {
        let orders = filteredOrders() // Get orders filtered by issued date
        return orders.ordersIssued.reduce(0) { $0 + $1.orderAmount }
    }
    
    private func formattedTotalIssuedAmount() -> String {
        let total = totalIssuedAmount()
        let formatter = currencyFormatter
        return formatter.string(from: NSNumber(value: total)) ?? "$0.00" // Fallback if formatting fails
    }
    
    private func totalExpectedAmount() -> Double {
        let orders = filteredOrders() // Get orders filtered by due date
        return orders.ordersDue.reduce(0) { $0 + $1.orderAmount }
    }
    
    private func formattedTotalExpectedAmount() -> String {
        let total = totalExpectedAmount()
        let formatter = currencyFormatter
        return formatter.string(from: NSNumber(value: total)) ?? "$0.00" // Fallback if formatting fails
    }
    
    private func totalPaidAmount() -> Double {
        let orders = filteredOrders() // Get orders filtered by payment status
        return orders.ordersPaid.reduce(0) { $0 + $1.orderAmount }
    }
    
    private func formattedTotalPaidAmount() -> String {
        let total = totalPaidAmount()
        let formatter = currencyFormatter
        return formatter.string(from: NSNumber(value: total)) ?? "$0.00" // Fallback if formatting fails
    }
    
    // Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    // Currency Formatter
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

enum Period {
    case currentWeek
    case currentMonth
    case custom
    
    func periodName(startDate: Date? = nil, endDate: Date? = nil) -> String {
        switch self {
        case .currentWeek:
            return "this week"
        case .currentMonth:
            return "this month"
        case .custom:
            guard let start = startDate, let end = endDate else { return "between dates" }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return "\(dateFormatter.string(from: start)) through \(dateFormatter.string(from: end))"
        }
    }
}
