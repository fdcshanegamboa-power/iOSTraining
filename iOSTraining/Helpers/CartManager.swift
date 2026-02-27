//
//  CartManager.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
//

import Foundation

class CartManager {

    static let shared = CartManager()
    private init() {}

    private(set) var items: [CartItem] = []

    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
    }

    func clear() {
        items.removeAll()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
}
