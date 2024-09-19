import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isShowingAddInteractionSheet: Bool = false
    @State private var showEditAccountSheet = false
    @State private var showInteractionSheet: Bool = false
    @State private var selectedInteraction: Interaction? = nil
    @State private var isShowingAddContactSheet: Bool = false
    @State private var isShowingAddOrderSheet: Bool = false
    @State private var isShowingSafariView: Bool = false
    @State private var isShowingInvalidURLAlert: Bool = false
    @State private var selectedAccount: Account?
    
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
                } header: {
                    Text("Account details")
                }
                
                if !account.generalNotes.isEmpty {
                    Section {
                        Text(account.generalNotes)
                    } header: {
                        Text("Notes")
                    }
                }
                
                
                Section {
                    Button {
                        isShowingAddInteractionSheet.toggle()
                    } label: {
                        Label("New Interaction", systemImage: "note.text.badge.plus")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddInteractionSheet) {
                        AddInteractionView(account: account)
                    }
                    if !account.interactions.isEmpty {
                        ForEach(account.interactions.sorted(by: { $0.date > $1.date }), id: \.id) { interaction in
                            
                            Button {
                                selectedInteraction = interaction
                                showInteractionSheet = true
                            } label: {
                                HStack {
                                    Text(interaction.date, format: .dateTime.month(.abbreviated).day().year())
                                    Text(" -  \(interaction.title)")
                                }
                                .foregroundStyle(Color.primary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            }
                        }
                    }
                } header: {
                    Text("Interactions")
                }
                
                Section {
                    Button {
                        isShowingAddContactSheet.toggle()
                    } label: {
                        Label("New Contact", systemImage: "person.crop.circle.badge.plus")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .sheet(isPresented: $isShowingAddContactSheet) {
                        AddContactView(account: account)
                    }
                    if !account.contacts.isEmpty {
                        ForEach(account.contacts, id: \.id) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                ContactRowView(contact: contact)
                            }
                        }
                    }
                } header: {
                    Text("Contacts")
                }
                
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
                            .environmentObject(modelData)
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
            .fullScreenCover(isPresented: $isShowingSafariView) {
                if let url = URL(string: "https://\(account.website)"), UIApplication.shared.canOpenURL(url) {
                    SafariView(url: url)
                } else {
                    Text("Invalid URL")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            .sheet(isPresented: Binding(
                get: { showInteractionSheet && selectedInteraction != nil },
                set: { newValue in showInteractionSheet = newValue }
            )) {
                InteractionDetailView(interaction: selectedInteraction!)
                    .presentationDragIndicator(.visible)
            }
            .alert(isPresented: $isShowingInvalidURLAlert) {
                Alert(
                    title: Text("Invalid URL"),
                    message: Text("The URL \"\(account.website)\" is invalid and cannot be opened."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        selectedAccount = account
                        showEditAccountSheet = true
                    }
                }
            }
            .sheet(isPresented: $showEditAccountSheet) { 
                if let accountToEdit = selectedAccount {
                    AddAccountView(isPresented: $showEditAccountSheet, accountToEdit: accountToEdit)
                        .environmentObject(modelData)
                }
            }
        }
    }
}
