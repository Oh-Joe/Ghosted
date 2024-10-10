import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("bustASale")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.horizontal)
                
                Button(action: login) {
                    Text("LOG IN")
                        .frame(maxWidth: 300)
                        .padding()
                        .padding(.horizontal, 32)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .background(.accent)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $isLoginSuccessful) {
                Home() // Navigate to Home when login is successful
            }
        }
    }
    
    private func login() {
        // Replace with your actual login logic
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }
        
        // Simulate a login check
        if username == "user" && password == "password" {
            isLoginSuccessful = true // This will trigger the navigation to Home
        } else {
            alertMessage = "Invalid username or password."
            showAlert = true
        }
    }
}
