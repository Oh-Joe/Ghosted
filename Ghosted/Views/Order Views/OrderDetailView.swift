import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataModel: DataModel

    @Binding var order: Order
    @State private var localOrder: Order
    
    var company: Company
    
    init(order: Binding<Order>, company: Company) {
        self._order = order
        self._localOrder = State(initialValue: order.wrappedValue)
        self.company = company
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(localOrder.orderAmount, format: .currency(code: localOrder.currency.rawValue))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    HStack {
                        Toggle("Paid?", isOn: $localOrder.isFullyPaid)
                    }
                } header: {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.opacity(0.3))
                        Text("Dollar dollar bills")
                    }
                }
                
                Section {
                    Text("Order #\(localOrder.orderNumber)")
                    Text("Due date: \(localOrder.dueDate, format: .dateTime.day().month())")
                        .foregroundStyle(!localOrder.isFullyPaid && localOrder.dueDate < Date() ? .red : .primary)
                } header: {
                    Text("Order Details")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text(localOrder.orderNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .onDisappear {
            order = localOrder
            dataModel.updateOrder(localOrder)
        }
    }
}
