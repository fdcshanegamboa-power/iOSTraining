//
//  AboutView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Name
                    VStack(spacing: 16) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(primaryColor)
                            .padding()
                            .background(
                                Circle()
                                    .fill(primaryColor.opacity(0.1))
                            )
                        
                        Text("iOSTraining")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Version \(appVersion) (\(buildNumber))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 30)
                    
                    // About Text
                    VStack(alignment: .leading, spacing: 20) {
                        sectionView(
                            title: "About This App",
                            content: """
                            iOSTraining is a comprehensive e-commerce training application designed to showcase modern iOS development practices using UIKit and SwiftUI.
                            
                            This app demonstrates:
                            • Hybrid UIKit/SwiftUI architecture
                            • MVVM design pattern
                            • Modern card-based UI design
                            • User authentication and profile management
                            • Shopping cart functionality
                            • Address management
                            • Product browsing and search
                            """
                        )
                        
                        sectionView(
                            title: "Built With",
                            content: """
                            • Swift & SwiftUI
                            • UIKit
                            • @Observable property wrapper
                            • URLSession for networking
                            • UserDefaults for local storage
                            • SF Symbols
                            """
                        )
                        
                        sectionView(
                            title: "Credits",
                            content: """
                            Developed by Shane Gamboa
                            
                            © 2026 iOSTraining. All rights reserved.
                            """
                        )
                        
                        sectionView(
                            title: "Contact",
                            content: """
                            Email: support@iostraining.com
                            Website: www.iostraining.com
                            Phone: +1 (555) 123-4567
                            """
                        )
                    }
                    .padding(.horizontal)
                    
                    // Social Links (Placeholder)
                    HStack(spacing: 24) {
                        socialButton(icon: "envelope.fill", label: "Email")
                        socialButton(icon: "globe", label: "Website")
                        socialButton(icon: "phone.fill", label: "Phone")
                    }
                    .padding(.vertical)
                    
                    Text("Made with ❤️ in San Francisco")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                }
            }
        }
    }
    
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(content)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func socialButton(icon: String, label: String) -> some View {
        Button(action: {
            // Placeholder action
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(primaryColor)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(primaryColor.opacity(0.1))
                    )
                
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    AboutView()
}
