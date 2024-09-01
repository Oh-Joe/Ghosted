//
//  SaveButton.swift
//  eYes
//
//  Created by Antoine Moreau on 8/31/24.
//

import SwiftUI

struct SaveButton: View {
    
    var buttonText: String
    var body: some View {
        Text(buttonText)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
    }
}

#Preview {
    SaveButton(buttonText: "Save")
}
