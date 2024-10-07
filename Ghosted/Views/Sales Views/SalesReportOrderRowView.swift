import SwiftUI

struct SalesOrderRowView: View {
    var order: Order
    var companyName: String // Pass the company name to the view

    var body: some View {
        HStack {
            paymentStatusIcon
            
            VStack(alignment: .leading) {
                Text(companyName)
                Text(order.orderNumber)
                Text("Amount: \(formattedAmount(order.orderAmount))")
                    .fontWeight(.bold)
            }
            .font(.caption)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Issued: \(order.issuedDate, formatter: dateFormatter)")
                Text("Due: \(order.dueDate, formatter: dateFormatter)")
                if order.isFullyPaid {
                    Text("Paid on: \(order.paidDate, formatter: dateFormatter)")
                }
            }
            .font(.caption)
        }
    }

    // Function to format the amount
    private func formattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    // Determine the payment status icon
    private var paymentStatusIcon: some View {
        if order.isFullyPaid {
            return Image(systemName: "checkmark.circle.fill") // Green checkmark if paid
                .foregroundColor(.green)
        } else if order.isOverdue {
            return Image(systemName: "exclamationmark.triangle") // Red warning sign if overdue
                .foregroundColor(.red)
        } else {
            return Image(systemName: "checkmark.circle") // Gray checkmark if open
                .foregroundColor(.gray)
        }
    }
    
    // Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
