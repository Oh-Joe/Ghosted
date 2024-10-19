import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var path: [AppRoute]

    let punchlines: [String] = [
        "Good news: You’re halfway through the week. Bad news: It’s Monday.",
        "Look, you could log in and close deals and stuff, or you could just **ck around and pretend to work. We're not judging!",
        "Welcome to the glamorous world of sales. Spoiler: It’s mostly emails and coffee.",
        "Ready to spend half your time tracking down leads, and the other half pretending you did?",
        "Welcome to your personal sales toolbox. No refunds for lost sanity."
        ]
    
    var body: some View {
        var randomPunchline: String = punchlines.randomElement()!
        VStack {
            Spacer()
            Image("bustASale")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(randomPunchline)
                .foregroundStyle(.secondary)
                .italic()
                .frame(width: 300)
            
            Spacer()
            
            Button(action: {
                path.append(.signIn)
            }) {
                Text("SIGN IN WITH EMAIL")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(width: 300)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: {
                path.append(.signUp)
            }) {
                Text("SIGN UP (NEW USER)")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(width: 300)
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
