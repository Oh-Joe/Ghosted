import SwiftUI

struct ContactMugView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    
    var contact: Contact
    
    var body: some View {
        ZStack {
            // Image Layer
            Group {
                if let contactImage = dataModel.getImage(for: contact) {
                    Image(uiImage: contactImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: 500)
            .padding()
            
            // Close Button Layer
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.accent)
                            .padding(6)
                            .background(.secondary.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}
