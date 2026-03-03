//
//  CartViewModel.swift
//  iOSTraining
//

import Foundation
import Observation

@Observable
final class CartViewModel {
    private let repository: CartRepositoryProtocol
    private let service: CartServiceProtocol
    
    var showingCheckoutAlert = false
    var searchText = ""
    var isSummaryExpanded = true
    
    init(
        repository: CartRepositoryProtocol = CartRepository(),
        service: CartServiceProtocol = CartService()
    ) {
        self.repository = repository
        self.service = service
    }
    
    var items: [CartItem] {
        let filtered = repository.items
        guard !searchText.isEmpty else { return filtered }
        
        return filtered.filter { item in
            item.product.title.localizedCaseInsensitiveContains(searchText) ||
            item.product.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var isEmpty: Bool {
        repository.items.isEmpty
    }
    
    var totalItems: Int {
        repository.selectedItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        repository.selectedTotalPrice
    }
    
    var hasSelectedItems: Bool {
        repository.hasSelectedItems
    }
    
    var allSelected: Bool {
        repository.allSelected
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        repository.updateQuantity(for: item, newQuantity: newQuantity)
    }
    
    func removeItem(_ item: CartItem) {
        repository.remove(product: item.product)
    }
    
    func toggleSelection(for item: CartItem) {
        service.toggleSelection(for: item)
    }
    
    func toggleSelectAll() {
        service.toggleSelectAll()
    }
    
    func toggleSummary() {
        isSummaryExpanded.toggle()
    }
    
    func checkout() {
        guard hasSelectedItems else { return }
        showingCheckoutAlert = true
    }
    
    func confirmCheckout() {
        service.checkout()
        showingCheckoutAlert = false
    }
}
