import SwiftUI

struct OrderListView: View {
    @State private var isShowingAddOrderSheet: Bool = false
    @State private var showOrderSheet: Bool = false
    @State private var selectedOrder: Order? = nil
    var account: Account
    
    @State private var sectionExpandedStates: [OrderSection: Bool] = [
        .overdue: true,
        .open: true,
        .settled: false
    ]
    
    enum OrderSection: String, CaseIterable {
        case overdue = "Overdue"
        case open = "Open"
        case settled = "Settled"
    }
    
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
                } header: {
                    Text("") // just for the space
                }
                
                ForEach(OrderSection.allCases, id: \.self) { section in
                    let ordersForSection = ordersForSection(section)
                    if !ordersForSection.isEmpty {
                        OrderSectionView(
                            section: section,
                            orders: ordersForSection,
                            isExpanded: sectionExpandedStates[section] ?? false,
                            toggleExpansion: {
                                withAnimation {
                                    sectionExpandedStates[section]?.toggle()
                                }
                            },
                            selectedOrder: $selectedOrder,
                            showOrderSheet: $showOrderSheet,
                            totalValue: totalValueForSection(ordersForSection)
                        )
                    }
                }
            }
            .navigationTitle(account.name)
            .sheet(isPresented: Binding(
                get: { showOrderSheet && selectedOrder != nil },
                set: { newValue in showOrderSheet = newValue }
            )) {
                if let selectedOrderBinding = Binding($selectedOrder) {
                    OrderDetailView(order: selectedOrderBinding, account: account)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    private func ordersForSection(_ section: OrderSection) -> [Order] {
        switch section {
        case .overdue:
            return account.orders.filter { $0.isOverdue }.sorted(by: { $0.dueDate < $1.dueDate })
        case .open:
            return account.orders.filter { !$0.isFullyPaid && !$0.isOverdue }.sorted(by: { $0.dueDate < $1.dueDate })
        case .settled:
            return account.orders.filter { $0.isFullyPaid }.sorted(by: { $0.dueDate > $1.dueDate })
        }
    }
    
    private func totalValueForSection(_ orders: [Order]) -> Double {
        orders.reduce(0) { $0 + $1.orderAmount }
    }
}

struct OrderSectionView: View {
    var section: OrderListView.OrderSection
    var orders: [Order]
    var isExpanded: Bool
    var toggleExpansion: () -> Void
    @Binding var selectedOrder: Order?
    @Binding var showOrderSheet: Bool
    var totalValue: Double
    
    var body: some View {
        Section {
            if isExpanded {
                ForEach(orders) { order in
                    Button {
                        selectedOrder = order
                        showOrderSheet = true
                    } label: {
                        OrderRowView(order: order)
                    }
                }
            }
        } header: {
            Button(action: toggleExpansion) {
                HStack {
                    Text(section.rawValue)
                    Text("\(orders.count)")
                        .font(.caption)
                        .frame(width: 15, height: 15)
                        .background(Circle().fill(Color.accentColor).opacity(0.3))
                    Text(totalValue, format: .currency(code: orders.first?.currency.rawValue ?? "USD"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut, value: isExpanded)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
