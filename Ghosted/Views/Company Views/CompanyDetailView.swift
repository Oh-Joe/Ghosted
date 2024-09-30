import SwiftUI

struct CompanyDetailView: View {
    @State private var isShowingSafariView: Bool = false
    @State private var isShowingInvalidURLAlert: Bool = false
    var company: Company
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.secondary)
                    Text(company.status.rawValue)
                }
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.secondary)
                    Text("\(company.country.rawValue)")
                }
                HStack {
                    Image(systemName: "list.clipboard")
                        .foregroundStyle(Color.secondary)
                    Text(company.companyType.rawValue)
                }
                
                Button {
                    var urlString = company.website
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
                        Text(company.website)
                    }
                }
            } header: {
                Text("") // just for the space
            }
            
            if !company.generalNotes.isEmpty {
                Section {
                    Text(company.generalNotes)
                } header: {
                    Text("Notes")
                }
            }
        }
        .navigationTitle(company.name)
        .fullScreenCover(isPresented: $isShowingSafariView) {
            if let url = URL(string: "https://\(company.website)"), UIApplication.shared.canOpenURL(url) {
                SafariView(url: url)
            } else {
                Text("Invalid URL")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
}


