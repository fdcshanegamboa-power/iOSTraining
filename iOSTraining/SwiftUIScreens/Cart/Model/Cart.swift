//
//  Cart.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/2/26.
// Cart/Model/Cart.swift

import Foundation
import SwiftUI

struct Cart {
    var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    mutating func add(_ product: Product, atPrice: Double? = nil, isFlashSale: Bool = false) {
        // Determine the effective price
        let effectivePrice: Double
        let isFlash: Bool
        
        if let providedPrice = atPrice {
            // Explicit price provided
            effectivePrice = providedPrice
            isFlash = isFlashSale
        } else {
            // No price provided - check if product is currently on flash sale
            if let flashItem = FlashSaleService.shared.currentFlashItems.first(where: { $0.product.id == product.id }) {
                effectivePrice = flashItem.flashPrice
                isFlash = true
            } else {
                effectivePrice = product.price
                isFlash = false
            }
        }
        
        // Check if product exists (by ID only)
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
            // Update price to current effective price
            items[index].pricePurchasedAt = effectivePrice
            items[index].isFlashSale = isFlash
        } else {
            // Add as new item
            items.append(CartItem(product: product, quantity: 1, isSelected: false, pricePurchasedAt: effectivePrice, isFlashSale: isFlash))
        }
    }
    
    mutating func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    mutating func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
    }
}
