import Foundation
import FirebaseAuth
import Combine

class AuthManager: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var errorMessage: String? = nil

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    func startListening() {
        // Adding the auth state change listener
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.isUserLoggedIn = user != nil
            self?.errorMessage = nil // Clear any previous error messages
        }
    }

    func stopListening() {
        // Removing the auth state change listener
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.isUserLoggedIn = true // Update the login state on successful sign-in
                self?.errorMessage = nil // Clear error message on successful sign-in
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false // Update the login state on sign out
            print("User signed out successfully") // Debugging line
        } catch let signOutError {
            errorMessage = signOutError.localizedDescription
            print("Error signing out: \(signOutError.localizedDescription)") // Debugging line
        }
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = nil // Clear error message on successful registration
            }
        }
    }
}
