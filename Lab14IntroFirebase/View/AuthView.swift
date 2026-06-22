//
//  AuthView.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 15/06/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authStateListener: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Lab 14: Firebase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                Spacer()
                if isSignedIn {
                    MessagesView()
                    
                } else {
                    // Sign in form
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack(spacing: 20) {
                            Button("Sign In") {
                                signIn()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            Button("Sign Up") {
                                signUp()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .padding(.horizontal, 30)
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onChange(of: isSignedIn) {
            // Clear form when signing out
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }
    
    // MARK: - Authentication Functions
    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = "Sign in failed: \(error.localizedDescription)"
                self.showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                guard let user = result?.user else { return }
                
                if let userEmail = user.email, userEmail.lowercased().hasSuffix("@tecsup.edu.pe") {
                    self.isSignedIn = true
                    self.alertMessage = "Sign in successful!"
                    self.showAlert = true
                } else {
                    try? Auth.auth().signOut()
                    self.isSignedIn = false
                    self.alertMessage = "Access denied. Only Tecsup users are allowed."
                    self.showAlert = true
                }
            }
        }
    }
    
    func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func checkAuthState() {
        // Listen for authentication state changes and store the listener handle
        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
    
    
    // MARK: - Button Styles
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    struct SecondaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.blue)
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    struct SignOutButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}

#Preview {
    AuthView()
}
