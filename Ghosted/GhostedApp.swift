import SwiftUI

@main
struct GhostedApp: App {
    @StateObject private var dataModel = DataModel()
    
    init() {
            NotificationManager.shared.requestPermission()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
        }
    }
}
