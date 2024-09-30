import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showNewNoteSheet: Bool = false
    @State private var showNoteSheet: Bool = false
    @State private var selectedNote: Note? = nil
        
    var contact: Contact
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "at")
                        .foregroundStyle(Color.secondary)
                    Text(contact.email)
                }
                HStack {
                    Image(systemName: "iphone.gen3")
                        .foregroundStyle(Color.secondary)
                    Text(contact.phoneNumber)
                }
            } header: {
                Text("Contact Details")
            }
            
            Section {
                Button {
                    showNewNoteSheet.toggle()
                } label: {
                    Label("New Note", systemImage: "note.text.badge.plus")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
            }
            
            
            let contactNotes = dataModel.notes.values.filter { $0.contactID == contact.id }.sorted(by: { $0.date > $1.date })
            if !contactNotes.isEmpty {
                Section {
                    ForEach(contactNotes) { note in
                        Button {
                            selectedNote = note
                            showNoteSheet = true
                        } label: {
                            HStack {
                                Text(note.date, format: .dateTime.month(.abbreviated).day().year())
                                Text(" -  \(note.title)")
                            }
                            .foregroundStyle(Color.primary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        }
                    }
                    .onDelete { indexSet in
                        let notesToDelete = indexSet.map { contactNotes[$0] }
                        for note in notesToDelete {
                            dataModel.deleteNote(note)
                        }
                    }
                } header: {
                    Text("Notes")
                }
            }
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                ContactRowView(contact: contact)
                    .padding(.horizontal, -8)
            }
        }
        .sheet(isPresented: $showNewNoteSheet) {
            AddNoteView(contact: contact)
        }
        .sheet(isPresented: Binding(
            get: { showNoteSheet && selectedNote != nil },
            set: { newValue in showNoteSheet = newValue }
        )) {
            NoteDetailView(note: selectedNote!)
                .presentationDragIndicator(.visible)
        }
        
    }
}
