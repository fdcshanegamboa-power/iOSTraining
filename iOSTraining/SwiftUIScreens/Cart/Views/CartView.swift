//
//  CartView.swift
//  iOSTraining
//
// Cart/Views/CartView.swift

import SwiftUI

struct CartView: View {
    @State private var viewModel = CartViewModel()
    @State private var promoCode: String = ""

    var body: some View {
        Group {
            if viewModel.isEmpty {
                emptyState
            } else {
                cartContent
            }
        }
        .safeAreaInset(edge: .bottom) {
            checkoutBar
        }
        .confirmationDialog(
            "Ready to purchase these items?",
            isPresented: $viewModel.showingCheckoutAlert,
            titleVisibility: .visible
        ) {
            Button("Confirm Purchase") {
                print("Purchase Confirmed!")
            }
            Button("Cancel", role: .cancel) {}
        }

    }

    // MARK: - Cart Content

    private var cartContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                HStack {
                    Text("\(viewModel.totalItems) Items")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
                
                ForEach(viewModel.items) { item in
                    CartRowView(item: item) { newQuantity in
                        viewModel.updateQuantity(for: item, newQuantity: newQuantity)
                    } onDelete: {
                        viewModel.removeItem(item)
                    }
                }

                promoCodeField
                orderSummary
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 120) // space for checkout bar
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView(
            "Your cart is empty",
            systemImage: "cart",
            description: Text("Add items to get started")
        )
    }

    // MARK: - Promo Code

    private var promoCodeField: some View {
        HStack {
            Image(systemName: "tag.circle")
                .foregroundStyle(.secondary)
                .font(.title3)

            TextField("Enter your promo code", text: $promoCode)
                .font(.subheadline)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Order Summary

    private var orderSummary: some View {
        VStack(spacing: 12) {
            summaryRow(label: "Subtotal", value: viewModel.totalPrice)
            Divider()
            summaryRow(label: "Shipping", value: 4.00)
            Divider()

            HStack {
                Text("Total amount")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("$\(viewModel.totalPrice + 4.00, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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

    // MARK: - Checkout Bar

    private var checkoutBar: some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                viewModel.checkout()
            } label: {
                Text("Proceed to Checkout")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.regularMaterial)
        }
    }
}

#Preview {
    CartView()
}
