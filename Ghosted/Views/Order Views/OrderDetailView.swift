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
                    Text(order.orderAmount, format: .currency(code: order.currency.rawValue))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: order.isFullyPaid ? "checkmark.circle.fill" : order.isOverdue ? "calendar.badge.exclamationmark" : "checkmark.circle")
                            .foregroundStyle(order.isFullyPaid ? .green : order.isOverdue ? .red : .secondary)
                        Text(order.isFullyPaid ? "Paid" : order.isOverdue ? "Overdue" : "Open")
                            .foregroundStyle(order.isFullyPaid ? .green : order.isOverdue ? .red : .primary)
                    }
                } header: {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.opacity(0.3))
                        Text("Dollar dollar bills")
                    }
                }
                
                Section {
                    Text("Order #\(order.orderNumber)")
                    Text("Due date: \(order.dueDate, format: .dateTime.day().month())")
                        .foregroundStyle(!order.isFullyPaid && order.dueDate < Date() ? .red : .primary)
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
                    Text(order.orderNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
    }
}
