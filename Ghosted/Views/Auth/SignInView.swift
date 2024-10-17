import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var path: [AppRoute]
    
    let punchlines: [String] = [
        "Welcome back! Time to turn rejection into motivation…\nYeah, right.",
        "Back for more rejection already?",
        "Good news: You’re halfway through the week. Bad news: It’s Monday.",
        "You could be closing deals, or just **cking around pretending to work. We're not judging!",
        "Welcome back! Time to explain your pipeline to the boss… again.",
        "Life could be worse. Like, you could be your own client.",
        "Welcome to your personal sales toolbox. No refunds for lost sanity."
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
                signIn()
            } label: {
                Text("SIGN IN")
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
                path = [] // Reset path on successful login
            }
        }
    }

    private func signIn() {
        authManager.signIn(email: email, password: password)
    }
}

