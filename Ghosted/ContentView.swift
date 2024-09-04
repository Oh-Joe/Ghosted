//
//  ContentView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selectedTab: Tab = .accounts

    var rando: Int = Int.random(in: 1...5)

    
    enum Tab {
        case accounts
        case contacts
    }

    var body: some View {
        
        NavigationStack {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: AccountListView()) {
                    VStack {

                        Image("SectionImageClientAccounts\(rando)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        Text("View your clients and leads.")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .foregroundStyle(Color.primary)
                    .padding()
                }
                .tag(Tab.accounts)
                

//                NavigationLink(destination: ContactListView()) {
//                    VStack {
//                        Image("SectionImageContacts")
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                        Spacer()
//                        Text("Keep tabs on the people.")
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity)
//                        Spacer()
//                    }
//                    .foregroundStyle(Color.primary)
//                    .padding()
//                }
//                .tag(Tab.contacts)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//            .navigationTitle(pageTitle)
            .navigationTitle("Home")
        }
    }
    
    // MARK: functions & helpers
    private var pageTitle: String {
        switch selectedTab {
        case .accounts:
            return "Accounts"
        case .contacts:
            return "Contacts"
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
