import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager() // Create an instance of AuthManager
    @State private var isUserLoggedIn: Bool = false // Track user login state

    var body: some View {
        NavigationStack {
            if isUserLoggedIn {
                Home(isUserLoggedIn: $isUserLoggedIn)
                    .environmentObject(authManager)
            } else {
                WelcomeView(isUserLoggedIn: $isUserLoggedIn)
                    .environmentObject(authManager)
            }
        }
        .onAppear {
            authManager.startListening() // Start listening for auth state changes
        }
        .onDisappear {
            authManager.stopListening() // Stop listening for auth state changes
        }
        .onChange(of: authManager.isUserLoggedIn) { newValue in
            print("Auth state changed: \(newValue)") // Debugging line
            isUserLoggedIn = newValue // Update the binding when logged in or out
        }
    }
}
