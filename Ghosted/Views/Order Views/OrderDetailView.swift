//
//  OrderDetailView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/30/24.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    
    var order: Order
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Order #\(order.orderNumber)")
                    Text(order.orderAmount, format: .currency(code: order.currency.rawValue)) // create logic to display this amount in an HStack with the correct currency symbol and color using a switch
                    Text("Due date: \(order.dueDate, format: .dateTime.day().month())")
                        .foregroundStyle(!order.isFullyPaid && order.dueDate < Date() ? .red : .primary)
                } header: {
                    Text("Order Details")
                }
            }
            .navigationTitle(order.orderNumber)
        }
    }
}

//struct CurrencySymbol: View {
//    var body: some View {
//        Image(systemName: symbol)
//            .foregroundStyle(Color.gray)
//        
//        var symbol: String {
//            switch Order.Currency() {
//            case .eur:
//                return "eurosign.circle"
//            case .gbp:
//                return "sterlingsign.circle"
//            case .usd:
//                return "dollarsign.circle"
//            }
//        }
//    }
//}

