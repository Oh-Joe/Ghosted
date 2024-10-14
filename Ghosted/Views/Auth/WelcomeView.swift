import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager // Access the AuthManager
    @State private var navigateToSignIn: Bool = false
    @State private var navigateToSignUp: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("bustASale")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()
                
                Button(action: {
                    navigateToSignIn = true // Trigger navigation to SignInView
                }) {
                    Text("Sign in with email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .background(
                    NavigationLink(destination: SignInView()
                                    .environmentObject(authManager),
                                   isActive: $navigateToSignIn) {
                        EmptyView()
                    }
                    .hidden() // Hide the navigation link
                )

                Button(action: {
                    navigateToSignUp = true // Trigger navigation to SignUpView
                }) {
                    Text("Sign up (new user)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .background(
                    NavigationLink(destination: SignUpView()
                                    .environmentObject(authManager),
                                   isActive: $navigateToSignUp) {
                        EmptyView()
                    }
                    .hidden() // Hide the navigation link
                )

                Spacer()
            }
            .padding()
            .onAppear {
                print("WelcomeView appeared")
                print("User login status: \(authManager.isUserLoggedIn.description)") // Debugging line
            }
        }
    }
}
