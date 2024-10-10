import SwiftUI
import Charts

struct SalesDashboardView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack {
            // Embed the ChartsView
            ChartsView()
                .frame(maxHeight: 300) // Adjust height as needed
            
            // Embed the SalesReportView
            SalesReportView()
                .frame(maxHeight: .infinity) // Allow it to take the remaining space
        }
        .navigationTitle("Sales Dashboard")
    }
}
