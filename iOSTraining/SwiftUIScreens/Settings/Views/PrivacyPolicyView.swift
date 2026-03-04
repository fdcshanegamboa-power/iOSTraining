//
//  PrivacyPolicyView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Effective Date: March 3, 2026")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    
                    sectionView(
                        title: "Introduction",
                        content: """
                        Welcome to iOSTraining. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our app and tell you about your privacy rights.
                        """
                    )
                    
                    sectionView(
                        title: "Information We Collect",
                        content: """
                        We may collect, use, store and transfer different kinds of personal data about you:
                        
                        • Identity Data: username, full name, date of birth
                        • Contact Data: email address, phone number, billing address, delivery addresses
                        • Financial Data: payment card details
                        • Transaction Data: details about payments and products you have purchased
                        • Technical Data: IP address, browser type, device information
                        • Usage Data: information about how you use our app
                        • Marketing Data: your preferences in receiving marketing from us
                        """
                    )
                    
                    sectionView(
                        title: "How We Use Your Information",
                        content: """
                        We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:
                        
                        • To register you as a new customer
                        • To process and deliver your orders
                        • To manage our relationship with you
                        • To improve our app and services
                        • To recommend products that may interest you
                        • To detect and prevent fraud
                        """
                    )
                    
                    sectionView(
                        title: "Data Security",
                        content: """
                        We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.
                        
                        We limit access to your personal data to those employees, agents, contractors and other third parties who have a business need to know. They will only process your personal data on our instructions and they are subject to a duty of confidentiality.
                        """
                    )
                    
                    sectionView(
                        title: "Data Retention",
                        content: """
                        We will only retain your personal data for as long as reasonably necessary to fulfill the purposes we collected it for, including for the purposes of satisfying any legal, regulatory, tax, accounting or reporting requirements.
                        
                        To determine the appropriate retention period for personal data, we consider the amount, nature and sensitivity of the personal data, the potential risk of harm from unauthorized use or disclosure, and the purposes for which we process your data.
                        """
                    )
                    
                    sectionView(
                        title: "Your Legal Rights",
                        content: """
                        Under certain circumstances, you have rights under data protection laws in relation to your personal data:
                        
                        • Request access to your personal data
                        • Request correction of your personal data
                        • Request erasure of your personal data
                        • Object to processing of your personal data
                        • Request restriction of processing your personal data
                        • Request transfer of your personal data
                        • Right to withdraw consent
                        """
                    )
                    
                    sectionView(
                        title: "Third-Party Links",
                        content: """
                        This app may include links to third-party websites, plug-ins and applications. Clicking on those links or enabling those connections may allow third parties to collect or share data about you.
                        
                        We do not control these third-party websites and are not responsible for their privacy statements. When you leave our app, we encourage you to read the privacy policy of every website or app you visit.
                        """
                    )
                    
                    sectionView(
                        title: "Cookies",
                        content: """
                        Our app may use cookies and similar tracking technologies to track activity and store certain information. You can instruct your device to refuse all cookies or to indicate when a cookie is being sent.
                        
                        If you do not accept cookies, you may not be able to use some features of our app.
                        """
                    )
                    
                    sectionView(
                        title: "Changes to Privacy Policy",
                        content: """
                        We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Effective Date" at the top.
                        
                        You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.
                        """
                    )
                    
                    sectionView(
                        title: "Contact Us",
                        content: """
                        If you have any questions about this Privacy Policy, please contact us:
                        
                        Email: privacy@iostraining.com
                        Phone: +1 (555) 123-4567
                        Address: 123 Tech Avenue, San Francisco, CA 94102
                        """
                    )
                    
                    Text("Last Updated: March 3, 2026")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
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
    }
}

#Preview {
    PrivacyPolicyView()
}
