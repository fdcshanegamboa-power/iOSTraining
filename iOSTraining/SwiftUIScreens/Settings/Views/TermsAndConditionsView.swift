//
//  TermsAndConditionsView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct TermsAndConditionsView: View {
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
                        title: "1. Acceptance of Terms",
                        content: """
                        By accessing and using the iOSTraining mobile application ("App"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these Terms & Conditions, please do not use this App.
                        """
                    )
                    
                    sectionView(
                        title: "2. Use License",
                        content: """
                        Permission is granted to temporarily download one copy of the materials on iOSTraining's App for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:
                        
                        • Modify or copy the materials
                        • Use the materials for any commercial purpose
                        • Attempt to reverse engineer any software contained in the App
                        • Remove any copyright or other proprietary notations
                        • Transfer the materials to another person or "mirror" the materials on any other server
                        """
                    )
                    
                    sectionView(
                        title: "3. Account Responsibilities",
                        content: """
                        When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms.
                        
                        You are responsible for safeguarding your password and for all activities or actions under your account. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.
                        """
                    )
                    
                    sectionView(
                        title: "4. User Content",
                        content: """
                        Our App may allow you to post, link, store, share and otherwise make available certain information, text, graphics, or other material. You are responsible for the content that you post on or through the App.
                        
                        By posting content, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such content on and through the App.
                        """
                    )
                    
                    sectionView(
                        title: "5. Purchases",
                        content: """
                        If you wish to purchase any product or service made available through the App, you may be asked to supply certain information relevant to your purchase including your credit card number, the expiration date of your credit card, your billing address, and your shipping information.
                        
                        We reserve the right to refuse or cancel your order at any time for reasons including but not limited to: product or service availability, errors in the description or price, or problems identified by our fraud detection systems.
                        """
                    )
                    
                    sectionView(
                        title: "6. Intellectual Property",
                        content: """
                        The App and its original content, features and functionality are and will remain the exclusive property of iOSTraining and its licensors. The App is protected by copyright, trademark, and other laws of both the United States and foreign countries.
                        """
                    )
                    
                    sectionView(
                        title: "7. Termination",
                        content: """
                        We may terminate or suspend your account and bar access to the App immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms.
                        """
                    )
                    
                    sectionView(
                        title: "8. Limitation of Liability",
                        content: """
                        In no event shall iOSTraining, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the App.
                        """
                    )
                    
                    sectionView(
                        title: "9. Changes to Terms",
                        content: """
                        We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect.
                        
                        What constitutes a material change will be determined at our sole discretion. By continuing to access or use our App after any revisions become effective, you agree to be bound by the revised terms.
                        """
                    )
                    
                    sectionView(
                        title: "10. Contact Us",
                        content: """
                        If you have any questions about these Terms, please contact us at:
                        
                        Email: support@iostraining.com
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
            .navigationTitle("Terms & Conditions")
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
    TermsAndConditionsView()
}
