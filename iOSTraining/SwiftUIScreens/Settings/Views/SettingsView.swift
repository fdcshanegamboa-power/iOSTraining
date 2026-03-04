//
//  SettingsView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingLogoutAlert = false
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingAbout = false
    
    @Environment(\.dismiss) private var dismiss
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var body: some View {
        NavigationStack {
            Form {
                legalSection
                appInfoSection
                accountSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
        .sheet(isPresented: $showingTerms) {
            TermsAndConditionsView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive, action: performLogout)
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
    
    // MARK: - Sections
    
    private var accountSection: some View {
        Section {
            Button(action: { showingLogoutAlert = true }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                        .foregroundStyle(.red)
                        .font(.title3)
                    
                    Text("Log Out")
                        .foregroundStyle(.red)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
            }
        } header: {
            Text("Account")
        } footer: {
            Text("You will be returned to the login screen")
                .font(.caption)
        }
    }
    
    private var legalSection: some View {
        Section("Legal") {
            Button(action: { showingTerms = true }) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundStyle(primaryColor)
                        .font(.title3)
                    
                    Text("Terms & Conditions")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            
            Button(action: { showingPrivacy = true }) {
                HStack {
                    Image(systemName: "hand.raised")
                        .foregroundStyle(primaryColor)
                        .font(.title3)
                    
                    Text("Privacy Policy")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        Section("App Information") {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundStyle(primaryColor)
                    .font(.title3)
                
                Text("Version")
                
                Spacer()
                
                Text("\(appVersion) (\(buildNumber))")
                    .foregroundStyle(.secondary)
            }
            
            Button(action: { showingAbout = true }) {
                HStack {
                    Image(systemName: "app.badge")
                        .foregroundStyle(primaryColor)
                        .font(.title3)
                    
                    Text("About")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func performLogout() {
        UserManager.shared.logout()
        
        // Get the scene delegate to navigate to login
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.showLoginScreen(animated: true)
        }
    }
}

#Preview {
    SettingsView()
}
