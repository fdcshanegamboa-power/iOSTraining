//
//  CartItem.swift
//  iOSTraining
//

import Foundation

struct CartItem: Identifiable, Codable {//, Equatable {
    let id: UUID
    let product: Product
    var quantity: Int
    var isSelected: Bool
    let pricePurchasedAt: Double  // Price at time of addition (preserves flash sale discounts)
    let isFlashSale: Bool         // Track if item was added during flash sale
    
    var subtotal: Double {
        pricePurchasedAt * Double(quantity)
    }
    
    var hasDiscount: Bool {
        pricePurchasedAt < product.price
    }
    
    var discountPercent: Int {
        guard hasDiscount else { return 0 }
        return Int(((product.price - pricePurchasedAt) / product.price) * 100)
    }
    
    init(product: Product, quantity: Int = 1, isSelected: Bool = false, pricePurchasedAt: Double? = nil, isFlashSale: Bool = false) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.isSelected = isSelected
        self.pricePurchasedAt = pricePurchasedAt ?? product.price
        self.isFlashSale = isFlashSale
    }
}
