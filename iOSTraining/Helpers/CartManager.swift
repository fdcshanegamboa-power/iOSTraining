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
        
        // Determine the effective price
        let effectivePrice: Double
        let isFlash: Bool
        
        if let providedPrice = atPrice {
            // Explicit price provided (from flash sale screen)
            effectivePrice = providedPrice
            isFlash = isFlashSale
        } else {
            // No price provided - check if product is currently on flash sale
            if let flashItem = FlashSaleService.shared.currentFlashItems.first(where: { $0.product.id == product.id }) {
                effectivePrice = flashItem.flashPrice
                isFlash = true
                print("🔥 Adding flash sale item at $\(effectivePrice) (original: $\(product.price))")
            } else {
                effectivePrice = product.price
                isFlash = false
            }
        }
        
        // Merge by product ID only (not by price)
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
            // Update price to current effective price
            items[index].pricePurchasedAt = effectivePrice
            items[index].isFlashSale = isFlash
        } else {
            // Add as new item
            items.append(CartItem(product: product, quantity: 1, isSelected: false, pricePurchasedAt: effectivePrice, isFlashSale: isFlash))
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
    
    /// Updates cart item prices based on current flash sale status
    func updatePricesForFlashSale() {
        let flashItems = FlashSaleService.shared.currentFlashItems
        print("🔄 Updating cart prices. Flash items count: \(flashItems.count)")
        
        // Build dictionary of product ID -> flash price
        var flashProductMap: [Int: Double] = [:]
        for item in flashItems {
            flashProductMap[item.product.id] = item.flashPrice
        }
        
        var hasChanges = false
        for index in items.indices {
            let productId = items[index].product.id
            
            if let flashPrice = flashProductMap[productId] {
                // Product is on flash sale - apply discount
                if items[index].pricePurchasedAt != flashPrice {
                    print("💰 Applying flash price to \(items[index].product.title): $\(items[index].pricePurchasedAt) → $\(flashPrice)")
                    items[index].pricePurchasedAt = flashPrice
                    items[index].isFlashSale = true
                    hasChanges = true
                }
            } else {
                // Product not on flash sale - revert to original price
                let originalPrice = items[index].product.price
                if items[index].isFlashSale && items[index].pricePurchasedAt != originalPrice {
                    print("📈 Reverting to original price for \(items[index].product.title): $\(items[index].pricePurchasedAt) → $\(originalPrice)")
                    items[index].pricePurchasedAt = originalPrice
                    items[index].isFlashSale = false
                    hasChanges = true
                }
            }
        }
        
        if hasChanges {
            print("✅ Cart prices updated and saved")
            save()
            // Force reload to ensure SwiftUI detects the changes
            items = load()
        } else {
            print("ℹ️ No cart price changes needed")
        }
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
