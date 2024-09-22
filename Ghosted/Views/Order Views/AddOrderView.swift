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
    
    @State var issuedDate = Date()
    @State var dueDate: Date? = nil
    @State var orderAmount: Double? = nil
    @State var currency: Order.Currency = .usd
    @State var orderNumber: String = ""
    @State var isFullyPaid: Bool = false
    
    var isFormValid: Bool {
        guard let orderAmount = orderAmount,
              let dueDate = dueDate else { return false }
        return orderAmount > 0 && !orderNumber.isEmpty && !dueDate.description.isEmpty
    }
    
    var account: Account
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Order number", text: $orderNumber)
                
                Section {
                    DatePicker("Issued on:", selection: $issuedDate, displayedComponents: .date)
                    DatePicker("Due date:", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: .date)
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
                        let newOrder = Order(id: UUID(),
                                             issuedDate: issuedDate,
                                             dueDate: dueDate ?? Date.now,
                                             orderAmount: orderAmount ?? 0,
                                             currency: currency,
                                             orderNumber: orderNumber,
                                             isFullyPaid: isFullyPaid
                        )
                        modelData.addOrder(newOrder, to: account)
                        modelData.objectWillChange.send()
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
