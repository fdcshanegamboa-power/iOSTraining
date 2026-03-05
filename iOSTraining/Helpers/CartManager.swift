//
//  CartManager.swift
//  iOSTraining
//

import Foundation
import Observation

@Observable
class CartManager {
    static let shared = CartManager()

    private let defaults = UserDefaults.standard
    private init(){
        self.items = load()
    }

    private(set) var items: [CartItem] = []
    
    private var cartKey: String {
        guard let userId = UserManager.shared.currentUser?.id else {
            return "guest_cart"
        }
        return "cart_\(userId)"
    }
    
    func add(product: Product, atPrice: Double? = nil, isFlashSale: Bool = false) {
        guard UserManager.shared.isLoggedIn else {
            print("⚠️ User not logged in. Cannot add to cart.")
            return
        }
        
        let effectivePrice = atPrice ?? product.price
        
        // Check if same product at same price exists
        if let index = items.firstIndex(where: { 
            $0.product.id == product.id && $0.pricePurchasedAt == effectivePrice 
        }) {
            items[index].quantity += 1
        } else {
            // Add as new item (handles same product with different prices)
            items.append(CartItem(product: product, quantity: 1, isSelected: false, pricePurchasedAt: effectivePrice, isFlashSale: isFlashSale))
        }
        save()
    }

    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
        save()
    }
    
    func removeSelected() {
        items.removeAll { $0.isSelected }
        save()
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
        save()
    }
    
    func toggleSelection(for item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isSelected.toggle()
        save()
    }
    
    func selectAll() {
        for index in items.indices {
            items[index].isSelected = true
        }
        save()
    }
    
    func deselectAll() {
        for index in items.indices {
            items[index].isSelected = false
        }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }
    
    func reloadCart(){
        self.items = load()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var selectedItems: [CartItem] {
        items.filter { $0.isSelected }
    }
    
    var selectedTotalItems: Int {
        selectedItems.reduce(0) { $0 + $1.quantity }
    }
    
    var selectedTotalPrice: Double {
        selectedItems.reduce(0) { $0 + $1.subtotal }
    }
    
    var hasSelectedItems: Bool {
        items.contains { $0.isSelected }
    }
    
    var allSelected: Bool {
        !items.isEmpty && items.allSatisfy { $0.isSelected }
    }

    var isEmpty: Bool {
        items.isEmpty
    }
    
    private func load() -> [CartItem] {
        guard let data = defaults.data(forKey: cartKey) else { return [] }
        return (try? JSONDecoder().decode([CartItem].self, from: data)) ?? []
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: cartKey)
        }
    }
}
