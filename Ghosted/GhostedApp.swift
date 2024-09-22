//
//  GhostedApp.swift
//  Ghosted
//
//  Created by Antoine Moreau on 8/31/24.
//

import SwiftUI

@main
struct GhostedApp: App {
    @StateObject private var modelData = ModelData()
    
    init() {
            NotificationManager.shared.requestPermission()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
