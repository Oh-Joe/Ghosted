import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case email
        case password
    }
    
    @Binding var path: [AppRoute]
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = .password
                }
                .submitLabel(.next)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .padding()

            SecureField("Password", text: $password)
                .focused($focusField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
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
