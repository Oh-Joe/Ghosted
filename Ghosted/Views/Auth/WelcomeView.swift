import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager // Access the AuthManager
    @Binding var isUserLoggedIn: Bool // Binding to track login state

    var body: some View {
        VStack {
            Image("bustASale")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button(action: {
                // Navigate to SignInView
                // You can use a sheet or full-screen cover for this
                // For example:
                isUserLoggedIn = true // Simulate successful login for testing
            }) {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: {
                // Navigate to SignUpView
                // You can use a sheet or full-screen cover for this
                // For example:
                isUserLoggedIn = true // Simulate successful signup for testing
            }) {
                Text("Sign up (new user)")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Spacer()
        }
        .padding()
        .onAppear {
            print("WelcomeView appeared") // Debugging line
        }
    }
}
