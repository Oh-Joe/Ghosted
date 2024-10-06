import SwiftUI

struct AddOrderView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    
    @State var issuedDate = Date()
    @State var orderAmount: Double? = nil
    @State var currency: Order.Currency = .usd
    @State var orderNumber: String = ""
    @State var isFullyPaid: Bool = false
    
    var isFormValid: Bool {
        guard let orderAmount = orderAmount else { return false }
        return orderAmount > 0 && !orderNumber.isEmpty
    }
    
    var company: Company
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Order number", text: $orderNumber)
                
                Section {
                    DatePicker("Issued on:", selection: $issuedDate, displayedComponents: .date)
                    // Due date no longer needed now that it's a computed property
//                    DatePicker("Due date:", selection: Binding(
//                        get: { dueDate ?? Date() },
//                        set: { dueDate = $0 }
//                    ), displayedComponents: .date)
                }
                
                Section {
                    TextField("Order amount:", value: $orderAmount.animation(), format: .currency(code: currency.rawValue))
                        .keyboardType(.decimalPad)
                    Picker("Currency:", selection: $currency) {
                        Text("Currency for this order:")
                        Divider()
                        ForEach(Order.Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                }
                Toggle("Fully paid yet?", isOn: $isFullyPaid)
            }
            .navigationTitle("New Order")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let expectedPaidDate = Calendar.current.date(byAdding: .day, value: company.paymentTerms.paymentTermsInt, to: issuedDate)!
                        let newOrder = Order(
                            id: UUID(),
                            issuedDate: issuedDate,
                            dueDate: expectedPaidDate,
                            orderAmount: orderAmount ?? 0,
                            currency: currency,
                            orderNumber: orderNumber,
                            isFullyPaid: isFullyPaid,
                            paidDate: expectedPaidDate,
                            companyID: company.id
                        )
                        dataModel.addOrder(newOrder, to: company)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}
