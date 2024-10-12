import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
            
            Image("bustASale")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            NavigationLink {
                SignInView()
            } label: {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            
            NavigationLink {
                SignUpView()
            } label: {
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
    }
}
