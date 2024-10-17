import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var path: [AppRoute]
    
    let punchlines: [String] = [
        "Welcome! If you thought job interviews were tough, wait until you meet clients.",
        "Congrats! You’ve just signed up for a lifetime of ‘circling back’ and ‘touching base.’",
        "Welcome to the glamorous world of sales. Spoiler: It’s mostly emails and coffee.",
        "Ready to spend half your time tracking down leads, and the other half pretending you did?",
        "Welcome to sales! May your coffee be strong and your clients… slightly interested.",
        "New to sales? Don’t worry, you’ll be dreaming about quotas in no time."
        ]
    
    var body: some View {
        var randomPunchline: String = punchlines.randomElement()!
        VStack {
            Text(randomPunchline)
                .font(.title2)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button {
                signUp()
            } label: {
                Text("SIGN UP")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(width: 300)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

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
