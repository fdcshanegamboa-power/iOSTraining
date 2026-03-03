//
//  CheckoutViewModel.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import Foundation
import Observation

enum CheckoutValidationError {
    case notLoggedIn
    case noAddress
    case noItems
    case none
    
    var message: String {
        switch self {
        case .notLoggedIn:
            return "You must be logged in to checkout"
        case .noAddress:
            return "Please add a delivery address to continue"
        case .noItems:
            return "Your cart is empty"
        case .none:
            return ""
        }
    }
    
    var title: String {
        switch self {
        case .notLoggedIn:
            return "Login Required"
        case .noAddress:
            return "Address Required"
        case .noItems:
            return "Empty Cart"
        case .none:
            return ""
        }
    }
}

@Observable
final class CheckoutViewModel {
    private let cartRepository: CartRepositoryProtocol
    private let cartService: CartServiceProtocol
    private let userRepository: UserRepositoryProtocol
    
    var validationError: CheckoutValidationError = .none
    var showingValidationAlert = false
    var showingAddAddressSheet = false
    var showingSuccessAlert = false
    var isProcessing = false
    var selectedAddressId: String?
    
    init(
        cartRepository: CartRepositoryProtocol = CartRepository(),
        cartService: CartServiceProtocol = CartService(),
        userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.cartRepository = cartRepository
        self.cartService = cartService
        self.userRepository = userRepository
        
        // Set default selected address
        if let defaultId = currentUser?.defaultAddressId {
            self.selectedAddressId = defaultId
        }
    }
    
    // MARK: - Computed Properties
    
    var currentUser: User? {
        userRepository.currentUser
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    var selectedItems: [CartItem] {
        cartRepository.selectedItems
    }
    
    var totalItems: Int {
        selectedItems.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        cartRepository.selectedTotalPrice
    }
    
    var shipping: Double {
        4.00
    }
    
    var tax: Double {
        subtotal * 0.1
    }
    
    var total: Double {
        subtotal + shipping + tax
    }
    
    var userAddresses: [Address] {
        currentUser?.addresses ?? []
    }
    
    var selectedAddress: Address? {
        guard let selectedId = selectedAddressId else { return nil }
        return userAddresses.first { $0.id == selectedId }
    }
    
    var hasAddress: Bool {
        !userAddresses.isEmpty
    }
    
    var canCheckout: Bool {
        isLoggedIn && hasAddress && !selectedItems.isEmpty
    }
    
    // MARK: - Validation
    
    func validate() -> Bool {
        // Check if user is logged in
        guard isLoggedIn else {
            validationError = .notLoggedIn
            showingValidationAlert = true
            return false
        }
        
        // Check if cart has items
        guard !selectedItems.isEmpty else {
            validationError = .noItems
            showingValidationAlert = true
            return false
        }
        
        // Check if user has address
        guard hasAddress else {
            validationError = .noAddress
            showingValidationAlert = true
            return false
        }
        
        // All validation passed
        validationError = .none
        return true
    }
    
    // MARK: - Actions
    
    func proceedToCheckout() {
        guard validate() else { return }
        // Validation passed - ready for final confirmation
    }
    
    func confirmPurchase() {
        guard validate() else { return }
        
        isProcessing = true
        
        // Simulate processing delay (in real app, this would be API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            // Process checkout
            self.cartService.checkout()
            
            self.isProcessing = false
            self.showingSuccessAlert = true
            
            print("✅ Checkout Completed")
            print("User: \(self.currentUser?.fullName ?? "Unknown")")
            print("Delivery Address: \(self.selectedAddress?.label ?? "Unknown")")
            print("Total: $\(String(format: "%.2f", self.total))")
        }
    }
    
    func selectAddress(id: String) {
        selectedAddressId = id
    }
    
    func showAddAddress() {
        showingAddAddressSheet = true
    }
}
