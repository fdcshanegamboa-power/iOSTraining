//
//  CartView.swift
//  iOSTraining
//

import SwiftUI

struct CartView: View {
    @State private var viewModel = CartViewModel()
    @State private var promoCode: String = ""
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)

    var body: some View {
        Group {
            if viewModel.isEmpty {
                emptyState
            } else {
                cartContent
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !viewModel.isEmpty {
                VStack(spacing: 0) {
                    orderSummarySection
                    checkoutBar
                }
            }
        }
        .confirmationDialog(
            "Ready to purchase these items?",
            isPresented: $viewModel.showingCheckoutAlert,
            titleVisibility: .visible
        ) {
            Button("Confirm Purchase") {
                viewModel.confirmCheckout()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Cart Content

    private var cartContent: some View {
        VStack(spacing: 0) {
            searchBar
            selectAllBar
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.items) { item in
                        CartRowView(
                            item: item,
                            primaryColor: primaryColor
                        ) { newQuantity in
                            viewModel.updateQuantity(for: item, newQuantity: newQuantity)
                        } onDelete: {
                            viewModel.removeItem(item)
                        } onToggleSelection: {
                            viewModel.toggleSelection(for: item)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 280) // space for summary + checkout
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search products...", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.regularMaterial)
    }

    // MARK: - Select All Bar

    private var selectAllBar: some View {
        HStack {
            Button {
                viewModel.toggleSelectAll()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: viewModel.allSelected ? "checkmark.square.fill" : "square")
                        .foregroundStyle(viewModel.allSelected ? primaryColor : .secondary)
                        .font(.title3)
                    
                    Text("Select All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            if viewModel.hasSelectedItems {
                Text("\(viewModel.totalItems) selected")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView(
            "Your cart is empty",
            systemImage: "cart",
            description: Text("Add items to get started")
        )
    }

    // MARK: - Order Summary Section

    private var orderSummarySection: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 0) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.toggleSummary()
                    }
                } label: {
                    HStack {
                        Text("Order Summary")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: viewModel.isSummaryExpanded ? "chevron.down" : "chevron.up")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                if viewModel.isSummaryExpanded {
                    VStack(spacing: 12) {
                        Divider()
                        
                        summaryRow(label: "Subtotal", value: viewModel.totalPrice)
                        summaryRow(label: "Shipping", value: 4.00)
                        summaryRow(label: "Tax", value: viewModel.totalPrice * 0.1)
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("$\(viewModel.totalPrice + 4.00 + (viewModel.totalPrice * 0.1), specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(primaryColor)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
            .background(.regularMaterial)
        }
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
        Button {
            viewModel.checkout()
        } label: {
            Text("Proceed to Checkout")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.hasSelectedItems ? primaryColor : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!viewModel.hasSelectedItems)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
    }
}

#Preview {
    CartView()
}
