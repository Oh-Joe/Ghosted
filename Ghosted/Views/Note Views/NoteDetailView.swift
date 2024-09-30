import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataModel: DataModel
    
    var note: Note
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(note.date, format: .dateTime.month(.abbreviated).day().year())
                        .fontWeight(.bold)
                    Divider()
                    ScrollView {
                        Text(note.content)
                        Spacer()    
                    }
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(note.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .padding(.top, 15)
    }
}

