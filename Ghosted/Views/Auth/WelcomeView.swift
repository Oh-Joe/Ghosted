import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var path: [AppRoute]

    var body: some View {
        VStack {
            Spacer()
            Image("bustASale")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
            
            Button(action: {
                path.append(.signIn)
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
                path.append(.signUp)
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
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .signIn:
                SignInView(path: $path).environmentObject(authManager)
            case .signUp:
                SignUpView(path: $path).environmentObject(authManager)
            default:
                EmptyView()
            }
        }
    }
}
