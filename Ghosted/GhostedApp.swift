import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      Auth.auth().useEmulator(withHost: "localhost", port: 9099)
      return true
  }
}

@main
struct GhostedApp: App {
    @StateObject private var dataModel = DataModel()
    
    init() {
            NotificationManager.shared.requestPermission()
        }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
        }
    }
}
