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
                    HStack {
                        Text("Order #:")
                        Spacer()
                        Text(localOrder.orderNumber)
                    }
                    HStack {
                        Text("Issued date:")
                        Spacer()
                        Text(localOrder.issuedDate.formatted(.dateTime.day().month(.abbreviated).year()))
                    }
                    HStack {
                        Text("Due date:")
                        Spacer()
                        Text(localOrder.dueDate.formatted(.dateTime.day().month(.abbreviated).year()))
                            .foregroundStyle(localOrder.isOverdue ? Color.red : .primary)
                    }
                } header: {
                    Text("Order Details")
                }
                
                Section {
                    
                    HStack {
                        Text("Amount:")
                        Spacer()
                        Text(localOrder.orderAmount, format: .currency(code: localOrder.currency.rawValue))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Toggle("Paid?", isOn: $localOrder.isFullyPaid)
                    }
                    DatePicker("Paid date:", selection: $localOrder.paidDate, displayedComponents: .date)
                } header: {
                    Text("Payment status")
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
