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
    
    var subtotal: Double {
        product.price * Double(quantity)
    }
    
    init(product: Product, quantity: Int = 1, isSelected: Bool = false) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.isSelected = isSelected
    }
    
//    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.product.id == rhs.product.id &&
//        lhs.quantity == rhs.quantity &&
//        lhs.isSelected == rhs.isSelected
//    }
}
