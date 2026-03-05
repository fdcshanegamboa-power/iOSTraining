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
        let effectivePrice = atPrice ?? product.price
        
        // Check if same product at same price exists
        if let index = items.firstIndex(where: { 
            $0.product.id == product.id && $0.pricePurchasedAt == effectivePrice 
        }) {
            items[index].quantity += 1
        } else {
            // Add as new item (handles different prices for same product)
            items.append(CartItem(product: product, quantity: 1, isSelected: false, pricePurchasedAt: effectivePrice, isFlashSale: isFlashSale))
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
