import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager // Access the AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToHome: Bool = false // State variable for navigation

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                signUp()
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .tint(.accent)
            .controlSize(.large)

            if let errorMessage = authManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            NavigationLink(destination: ContentView().environmentObject(authManager),
                           isActive: $navigateToHome) {
                EmptyView()
            }
            .hidden() // Hide the navigation link
        )
        .onChange(of: authManager.isUserLoggedIn) { oldValue, newValue in
            if newValue {
                navigateToHome = true // Trigger navigation to ContentView
            }
        }
    }

    private func signUp() {
        authManager.register(email: email, password: password) // Use the AuthManager to register
    }
}
