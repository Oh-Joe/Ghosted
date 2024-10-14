import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            if authManager.isUserLoggedIn {
                Home() // Show Home view for logged-in users
            } else {
                WelcomeView() // Show WelcomeView for logged-out users
            }
        }
    }
}
