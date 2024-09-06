//
//  OrderRowView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/31/24.
//

import SwiftUI

struct OrderRowView: View {
    @EnvironmentObject var modelData: ModelData
    var order: Order
    
    var body: some View {
        HStack {
            Image(systemName: order.isFullyPaid ? "checkmark.circle.fill" : order.isOverdue ? "calendar.badge.exclamationmark" : "checkmark.circle")
                .foregroundStyle(order.isFullyPaid ? .green : order.isOverdue ? .red : .secondary)
            
            Text(order.issuedDate, format: .dateTime.day().month(.abbreviated).year())
            
            Text(order.orderNumber)
            
            Text(order.orderAmount, format: .currency(code: order.currency.rawValue))
        }
        .font(.caption2)
        .foregroundStyle(!order.isFullyPaid && order.dueDate < Date() ? .red : .primary)
        .padding(.horizontal, 3)
    }
}


