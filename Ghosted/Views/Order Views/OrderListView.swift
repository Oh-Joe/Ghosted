//
//  OrderListView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct OrderListView: View {
    
    @State private var isShowingAddOrderSheet: Bool = false
    @State private var showOrderSheet: Bool = false
    @State private var selectedOrder: Order? = nil
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddOrderSheet.toggle()
                    } label: {
                        Label("New Order", systemImage: "dollarsign.square")
                            .foregroundStyle(Color.green)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .sheet(isPresented: $isShowingAddOrderSheet) {
                        AddOrderView(account: account)
                    }
                    if !account.orders.isEmpty {
                        ForEach(account.orders.sorted(by: { $0.issuedDate > $1.issuedDate })) { order in
                            Button {
                                selectedOrder = order
                                showOrderSheet = true
                            } label: {
                                OrderRowView(order: order)
                            }
                        }
                    }
                } 
            }
            .navigationTitle(account.name)
            .sheet(isPresented: Binding(
                get: { showOrderSheet && selectedOrder != nil },
                set: { newValue in showOrderSheet = newValue }
            )) {
                if let selectedOrderBinding = Binding($selectedOrder) {
                    OrderDetailView(order: selectedOrderBinding, account: account)  // Safely unwrap the optional binding
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}
