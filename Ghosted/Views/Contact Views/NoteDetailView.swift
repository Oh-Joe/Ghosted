//
//  NoteDetailView.swift
//  eYes
//
//  Created by Antoine Moreau on 8/29/24.
//

import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var modelData: ModelData
    
    var note: Contact.Note
    
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text(note.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(.top, 15)
    }
}

