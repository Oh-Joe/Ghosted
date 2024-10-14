import Foundation
import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false // Persist user login state
    @Published var errorMessage: String?
    
    func signIn(email: String, password: String) {
        // Sign in logic
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.errorMessage = nil
            self.isUserLoggedIn = true // Set login state to true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false // Reset login state
        } catch {
            errorMessage = "Error signing out"
        }
    }
    
    func register(email: String, password: String) {
        // Registration logic
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isUserLoggedIn = true // Set login state to true
        }
    }
}
