//
//  ContactDetailView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var newNote: String = ""
    @State private var showNewNoteSheet: Bool = false
    @State private var showNoteSheet: Bool = false
    @State private var selectedNote: Contact.Note? = nil
    
    var contact: Contact
    
    var body: some View {
        NavigationStack {
            ContactRowView(contact: contact)
                .padding(.horizontal)
            
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
                    .sheet(isPresented: $showNewNoteSheet) {
                        
                        AddNoteView(contact: contact) { newNote in
                            modelData.addNoteToContact(newNote, to: contact)
                        }
                        
                        
                    }
                    if !contact.notes.isEmpty {
                        ForEach(contact.notes.sorted(by: { $0.date > $1.date }), id: \.self) { note in
                            Button {
                                selectedNote = note
                                showNoteSheet = true
                            } label: {
                                HStack {
                                    Text(note.date, format: .dateTime.month(.abbreviated).day().year())
                                    Text(" -  \(note.title)")
                                }
                                .lineLimit(1)
                                .truncationMode(.tail)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let note = contact.notes.sorted(by: { $0.date > $1.date })[index]
                                modelData.deleteNoteFromContact(note, from: contact)
                            }
                        }
                    }
                } header: {
                    Text("Notes")
                }
                
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("\(contact.firstName) \(contact.lastName)")
            
            .sheet(isPresented: Binding(
                get: { showNoteSheet && selectedNote != nil },
                set: { newValue in showNoteSheet = newValue }
            )) {
                NoteDetailView(note: selectedNote!)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    ContactDetailView(contact: ModelData().contacts[0])
        .environmentObject(ModelData())
}

