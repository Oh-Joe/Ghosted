import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct GhostedApp: App {
    @StateObject private var dataModel = DataModel()
    @StateObject private var authManager = AuthManager()
    
    init() {
            NotificationManager.shared.requestPermission()
        }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
                .environmentObject(authManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase!")
        return true
    }
}
