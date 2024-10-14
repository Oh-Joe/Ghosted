import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToHome: Bool = false

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign In") {
                signIn()
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

    private func signIn() {
        authManager.signIn(email: email, password: password)
    }
}
