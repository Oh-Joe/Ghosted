//
//  AccountsHomeView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct AccountsHomeView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedAccount: Account?
    
    var account: Account
    
    var body: some View {
        
        NavigationStack {
            
            TabView {
                NewAccountDetailView(account: account)
                    .tabItem {
                        Label("Details", systemImage: "list.bullet.clipboard")
                    }
                ContactListView(account: account)
                    .tabItem {
                        Label("Contacts", systemImage: "person.2.fill")
                    }
                InteractionListView(account: account)
                    .tabItem {
                        Label("Interactions", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                OrderListView(account: account)
                    .tabItem {
                        Label("Orders", systemImage: "dollarsign.circle.fill")
                    }
                TaskListView(account: account)
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
            }
            .navigationTitle(account.name)
        }
        
    }
}
