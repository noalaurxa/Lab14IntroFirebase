//
//  QueryTestView.swift
//  Lab14IntroFirebase
//
//  Created by Tecsup on 22/06/26.
//

import SwiftUI
struct QueryTestView: View {
    @StateObject private var queryService = PostQueryService()
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Query Description
                if !queryService.queryDescription.isEmpty {
                    VStack {
                        Text("Current Query:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(queryService.queryDescription)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                // Query Buttons
                ScrollView {
                    LazyVStack(spacing: 10) {
                        
                        // WHERE Queries Section
                        querySection(title: "WHERE Queries") {
                            queryButton("Swift Posts", color: .blue) {
                                queryService.getPostsByCategory("swift")
                            }
                            queryButton("Popular Posts (>10 likes)", color: .orange) {
                                queryService.getPopularPosts()
                            }
                        }
                        
                        // ORDER BY Queries Section
                        querySection(title: "ORDER BY Queries") {
                            queryButton("Newest First", color: .indigo) {
                                queryService.getPostsByNewest()
                            }
                        }
                        
                        // LIMIT Queries Section
                        querySection(title: "LIMIT Queries") {
                            queryButton("First 3 Posts", color: .brown) {
                                queryService.getFirst3Posts()
                            }
                        }
                 
                        // Utility Section
                        querySection(title: "Utilities") {
                            queryButton("Add Sample Data", color: .gray) {
                                queryService.addSamplePosts()
                            }
                        }
                    }
                }
                
                // Results Section
                if queryService.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    List(queryService.posts) { post in
                        PostRowView(post: post)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Firestore Queries")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    // MARK: - Helper Views
    
    private func querySection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                content()
            }
            .padding(.horizontal)
        }
    }
    
    private func queryButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(8)
        }
    }
}
// MARK: - Post Row View
struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Title and Category
            HStack {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(post.category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor(post.category))
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            
            // Content Preview
          
            HStack {
                Text("By: \(post.authorEmail)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(post.likes)")
                            .font(.caption)
                    }
                    
                    Text(post.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category.lowercased() {
        case "swift": return .blue
        case "kotlin": return .orange
        case "google": return .green
        default: return .gray
        }
    }
}
#Preview {
    QueryTestView()
}
