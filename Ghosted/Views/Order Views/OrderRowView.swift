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
            VStack {
                Text(order.issuedDate, format: .dateTime.day().month(.abbreviated))
                Divider()
                Text(order.issuedDate, format: .dateTime.year())
            }
            .font((.caption))
            .background(Color.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(order.orderNumber)
                .font((.caption))
                .background(Color.secondary.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(order.orderAmount, format: .currency(code: order.currency.rawValue))
                .font((.caption))
                .background(Color.secondary.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
    }
}


