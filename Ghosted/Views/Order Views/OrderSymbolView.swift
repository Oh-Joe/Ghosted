//
//  OrderSymbolView.swift
//  Ghosted
//
//  Created by Antoine Moreau on 9/8/24.
//

import SwiftUI

struct OrderSymbolView: View {
    var body: some View {
        ZStack {
            Image(systemName: "clipboard")
                .font(.system(size: 48))
            Image(systemName: "dollarsign")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .offset(y: 4)
            
                .overlay {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 26))
                        .offset(x: 16, y: 26)
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .offset(x: 16, y: 26)
                        
                        
                }
            
            
        }
    }
}

#Preview {
    OrderSymbolView()
}
