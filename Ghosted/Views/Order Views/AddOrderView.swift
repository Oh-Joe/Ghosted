//
//  AddOrderView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/30/24.
//

import SwiftUI

struct AddOrderView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    
    @State var id = UUID()
    @State var issuedDate = Date()
    @State var dueDate: Date? = nil
    @State var orderAmount: Double? = nil
    @State var currency: Order.Currency = .usd
    @State var orderNumber: String = ""
    @State var isFullyPaid: Bool = false
    
    var isFormValid: Bool {
        guard let orderAmount = orderAmount,
              let dueDate = dueDate else { return false }
        return !orderAmount.isNaN && !orderNumber.isEmpty && !dueDate.description.isEmpty
    }
    
    var account: Account
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Order number", text: $orderNumber)
                
                Section {
                    DatePicker("Issued on:", selection: $issuedDate, displayedComponents: .date)
                        .onChange(of: issuedDate) { _ in
                            UIApplication.shared.dismissKeyboard()
                        }
                    DatePicker("Due date:", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: .date)
                        .onChange(of: dueDate) { _ in
                            UIApplication.shared.dismissKeyboard()
                        }
                }
                
                Section {
                    TextField("Order amount:", value: Binding(
                        get: { orderAmount ?? 0 },
                        set: { orderAmount = $0 }
                    ), format: .currency(code: currency.rawValue))
                        .keyboardType(.decimalPad)
                    Picker("Currency:", selection: $currency) {
                        Text("What will they pay in?")
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
                        let newOrder = Order(id: id,
                                             issuedDate: issuedDate,
                                             dueDate: dueDate ?? Date(),
                                             orderAmount: orderAmount ?? 0,
                                             currency: currency,
                                             orderNumber: orderNumber,
                                             isFullyPaid: isFullyPaid
                        )
                        modelData.addOrder(newOrder, to: account)
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

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
