//
//  CheckoutView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CheckoutViewModel()
    @State private var showingConfirmation = false
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                userInfoSection
                addressSection
                orderSummarySection
                confirmButton
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $viewModel.showingAddAddressSheet) {
            AddAddressView {
                // Refresh after address is added
                viewModel = CheckoutViewModel()
            }
        }
        .alert(viewModel.validationError.title, isPresented: $viewModel.showingValidationAlert) {
            if viewModel.validationError == .noAddress {
                Button("Add Address") {
                    viewModel.showAddAddress()
                }
                Button("Cancel", role: .cancel) {}
            } else {
                Button("OK", role: .cancel) {}
            }
        } message: {
            Text(viewModel.validationError.message)
        }
        .alert("Order Confirmed!", isPresented: $viewModel.showingSuccessAlert) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Your order has been placed successfully!\nTotal: $\(viewModel.total, specifier: "%.2f")")
        }
        .alert(
            "Confirm your purchase?",
            isPresented: $showingConfirmation
        ) {
            Button("Confirm Purchase") {
                viewModel.confirmPurchase()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Total amount: $\(viewModel.total, specifier: "%.2f")")
        }
    }
    
    // MARK: - User Info Section
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Customer Information", icon: "person.fill")
            
            if let user = viewModel.currentUser {
                VStack(spacing: 8) {
                    infoRow(label: "Name", value: user.fullName)
                    Divider()
                    infoRow(label: "Email", value: user.email)
                    if let phone = user.phoneNumber, !phone.isEmpty {
                        Divider()
                        infoRow(label: "Phone", value: phone)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                notLoggedInView
            }
        }
    }
    
    private var notLoggedInView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text("You must be logged in to checkout")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Address Section
    
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionHeader(title: "Delivery Address", icon: "location.fill")
                Spacer()
                if viewModel.hasAddress {
                    Button {
                        viewModel.showAddAddress()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                }
            }
            
            if viewModel.hasAddress {
                VStack(spacing: 12) {
                    ForEach(viewModel.userAddresses) { address in
                        addressCard(address)
                            .onTapGesture {
                                viewModel.selectAddress(id: address.id)
                            }
                    }
                }
            } else {
                noAddressView
            }
        }
    }
    
    private func addressCard(_ address: Address) -> some View {
        let isSelected = viewModel.selectedAddressId == address.id
        
        return HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? primaryColor : .secondary)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(address.label)
                        .font(.headline)
                    
                    if address.isDefault {
                        Text("Default")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(primaryColor.opacity(0.2))
                            .foregroundStyle(primaryColor)
                            .clipShape(Capsule())
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(address.street)
                    Text("\(address.city), \(address.state) \(address.zipCode)")
                    Text(address.country)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 2)
                )
        )
    }
    
    private var noAddressView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "mappin.slash")
                    .foregroundStyle(.secondary)
                Text("No delivery address found")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                viewModel.showAddAddress()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Address")
                }
                .fontWeight(.medium)
                .foregroundStyle(primaryColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Order Summary Section
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Order Summary", icon: "cart.fill")
            
            VStack(spacing: 0) {
                // Items List
                ForEach(viewModel.selectedItems) { item in
                    itemRow(item)
                    if item.id != viewModel.selectedItems.last?.id {
                        Divider()
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                // Price Breakdown
                VStack(spacing: 8) {
                    summaryRow(label: "Subtotal", value: viewModel.subtotal)
                    summaryRow(label: "Shipping", value: viewModel.shipping)
                    summaryRow(label: "Tax", value: viewModel.tax)
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(viewModel.total, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(primaryColor)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func itemRow(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            // Product Image
            AsyncImage(url: URL(string: item.product.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Text("Qty: \(item.quantity)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if item.isFlashSale {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.red)
                        Text("Flash Sale")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            Spacer()
            
            Text("$\(item.subtotal, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
    }
    
    private func summaryRow(label: String, value: Double) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text("$\(value, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Confirm Button
    
    private var confirmButton: some View {
        Button {
            if viewModel.validate() {
                showingConfirmation = true
            }
        } label: {
            HStack {
                if viewModel.isProcessing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Confirm Purchase")
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(viewModel.canCheckout ? primaryColor : Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!viewModel.canCheckout || viewModel.isProcessing)
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(primaryColor)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
    }
}
