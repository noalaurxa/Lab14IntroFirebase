//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 15/06/26.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""
    

    @State private var showingProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 16) {
                    Text("Messages")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: QueryTestView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    
                    Button("Profile") {
                        showingProfile = true
                    }
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Sign Out") {
                        try? Auth.auth().signOut()
                    }
                    .foregroundColor(.red)
                }
                .padding(.bottom, 10)
                
                List(databaseService.messages) { message in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.userEmail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(message.text)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                HStack {
                    TextField("Type a message...", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Send") {
                        if !newMessage.isEmpty {
                            databaseService.addMessage(text: newMessage)
                            newMessage = ""
                        }
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding(.top, 8)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            databaseService.startListening()
        }
        .sheet(isPresented: $showingProfile) {
            UserProfileView()
        }
    }
}

#Preview {
    MessagesView()
}
