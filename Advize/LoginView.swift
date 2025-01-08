//
//  LoginView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//


import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Text(isSignUp ? "Sign Up" : "Login")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Button(action: handleAuthentication) {
                Text(isSignUp ? "Sign Up" : "Login")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
    
    func handleAuthentication() {
        errorMessage = ""
        if isSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
