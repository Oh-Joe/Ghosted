import SwiftUI

enum AppRoute: Hashable {
    case home
    case signIn
    case signUp
}

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var path: [AppRoute] = [] // Use AppRoute enum for path

    var body: some View {
        NavigationStack(path: $path) {
            if authManager.isUserLoggedIn {
                Home() // Show Home view for logged-in users
            } else {
                WelcomeView(path: $path) // Pass the path to WelcomeView
            }
        }
        .onChange(of: authManager.isUserLoggedIn) { oldValue, newValue in
            if !newValue {
                path = [] // Reset path when user logs out
            }
        }
    }
}
