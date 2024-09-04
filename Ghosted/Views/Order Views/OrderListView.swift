//
//  OrderListView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct OrderListView: View {
    
    @State private var isShowingAddOrderSheet: Bool = false
    
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        isShowingAddOrderSheet.toggle()
                    } label: {
                        Label("New Order", systemImage: "banknote")
                            .foregroundStyle(Color.green)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .sheet(isPresented: $isShowingAddOrderSheet) {
                        AddOrderView(account: account)
                    }
                    if !account.orders.isEmpty {
                        ForEach(account.orders) { order in
                            NavigationLink(destination: OrderDetailView(order: order)) {
                                OrderRowView(order: order)                }
                        }
                    }

                } header: {
                    Text("Orders")
                }
            }
            .navigationTitle(account.name)
        }
    }
}
