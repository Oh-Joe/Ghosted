//
//  AddInteractionView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/2/24.
//

import SwiftUI

struct AddInteractionView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss
    
    @State var id = UUID()
    @State var date: Date = Date()
    @State var title: String = ""
    @State var content: String = ""
    
    var isFormValid: Bool {
        !date.description.isEmpty && !title.isEmpty && !content.isEmpty
    }
    
    var account: Account
    
    var body: some View {
        NavigationStack {
            
            Form {
                DatePicker("Date",
                           selection: $date,
                           displayedComponents: [.date]
                )
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 250)
            }
            .navigationTitle("New Interaction")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let newInteraction = Interaction(id: id,
                                                         date: date,
                                                         title: title,
                                                         content: content
                        )
                        modelData.addInteraction(newInteraction, to: account)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

