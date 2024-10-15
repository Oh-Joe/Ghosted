import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var path: [AppRoute]

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
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding()
        .onChange(of: authManager.isUserLoggedIn) { oldValue, newValue in
            if newValue {
                path = [] // Reset path on successful registration
            }
        }
    }

    private func signUp() {
        authManager.register(email: email, password: password) // Use AuthManager to register
    }
}
