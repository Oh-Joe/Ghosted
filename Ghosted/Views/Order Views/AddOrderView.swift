import SwiftUI

struct AddOrderView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    
    @State var issuedDate = Date()
    @State var orderAmountInput: String = ""
    @State var orderAmount: Double? = nil
    @State var currency: Order.Currency = .usd
    @State var orderNumber: String = ""
    @State var isFullyPaid: Bool = false
    @FocusState private var isOrderAmountFocused: Bool
    
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
                }
                
                Section {
                    TextField("Order amount", text: $orderAmountInput)
                        .keyboardType(.decimalPad)
                        .focused($isOrderAmountFocused)
                        .onChange(of: isOrderAmountFocused) { oldValue, focused in
                            if !focused {
                                // Apply currency formatting only when the TextField loses focus
                                if let amount = Double(orderAmountInput) {
                                    orderAmount = amount
                                    orderAmountInput = String(format: "%.2f", amount)
                                } else {
                                    orderAmount = nil // Reset if input is invalid
                                }
                            }
                        }
                    Picker("Currency:", selection: $currency) {
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
