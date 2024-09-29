import SwiftUI

struct ContactRowView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showContactMug: Bool = false
    let contact: Contact
    
    var body: some View {
        HStack {
            Button {
                showContactMug = true
            } label: {
                if let contactImage = dataModel.getImage(for: contact) {
                    Image(uiImage: contactImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading) {
                Text("\(contact.firstName) ") + Text(contact.lastName).fontWeight(.bold)
                Text(contact.jobTitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .sheet(isPresented: $showContactMug) {
            ContactMugView(contact: contact)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
