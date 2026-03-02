//
//  CartManager.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
// CartManager.swift

import Foundation
import Observation

@Observable
class CartManager {
    static let shared = CartManager()
    private init() {}

    private(set) var items: [CartItem] = []

    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product))
        }
    }

    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
    }

    func clear() {
        items.removeAll()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var isEmpty: Bool {
        items.isEmpty
    }
}
