//
//  CartItem.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/2/26.
// Cart/Model/CartItem.swift

import Foundation

struct CartItem: Identifiable {
    let id: UUID
    let product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int = 1) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
    }
    
    var subtotal: Double {
        product.price * Double(quantity)
    }
}
