//
//  NewAccountDetailView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/4/24.
//

import SwiftUI

struct AccountDetailView: View {
    @State private var isShowingSafariView: Bool = false
    @State private var isShowingInvalidURLAlert: Bool = false
    var account: Account
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(Color.secondary)
                        Text(account.status.rawValue)
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundStyle(Color.secondary)
                        Text("\(account.country.rawValue)")
                    }
                    HStack {
                        Image(systemName: "list.clipboard")
                            .foregroundStyle(Color.secondary)
                        Text(account.accountType.rawValue)
                    }
                    
                    Button {
                        var urlString = account.website
                        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                            urlString = "https://" + urlString
                        }
                        
                        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                            isShowingSafariView = true
                        } else {
                            isShowingInvalidURLAlert = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundStyle(Color.secondary)
                            Text(account.website)
                        }
                    }
                } 
                
                if !account.generalNotes.isEmpty {
                    Section {
                        Text(account.generalNotes)
                    } header: {
                        Text("Notes")
                    }
                }
            }
            .navigationTitle(account.name)
            .fullScreenCover(isPresented: $isShowingSafariView) {
                if let url = URL(string: "https://\(account.website)"), UIApplication.shared.canOpenURL(url) {
                    SafariView(url: url)
                } else {
                    Text("Invalid URL")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}


