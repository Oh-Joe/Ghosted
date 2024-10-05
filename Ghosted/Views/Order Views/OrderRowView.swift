import SwiftUI

struct OrderRowView: View {
    var order: Order
    
    var body: some View {
        
        HStack {
            Image(systemName: order.isFullyPaid ? "checkmark.circle.fill" : order.isOverdue ? "exclamationmark.triangle.fill" : "checkmark.circle")
                .foregroundStyle(order.isFullyPaid ? .green : order.isOverdue ? .red : .secondary)
            
            VStack(alignment: .leading) {
                Text(order.orderNumber)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                let displayDueDate = order.dueDate.formatted(.dateTime.day().month(.abbreviated).year())
                Text("Due: \(displayDueDate)")
                    .font(.caption)
            }
            Spacer()
            Text(order.orderAmount, format: .currency(code: order.currency.rawValue))
                .fontWeight(.semibold)
        }
        .foregroundStyle(order.isOverdue ? .red : .primary)
    }
}


