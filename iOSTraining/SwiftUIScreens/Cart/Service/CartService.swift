//
//  CartService.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/2/26.
// Cart/Service/CartService.swift

import Foundation

protocol CartServiceProtocol {
    var items: [CartItem] { get }
    var totalPrice: Double { get }
    var totalItems: Int { get }
    var isEmpty: Bool { get }
    func addToCart(product: Product)
    func removeFromCart(product: Product)
    func updateQuantity(for item: CartItem, newQuantity: Int)
    func clearCart()
}

final class CartService: CartServiceProtocol {
    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol = CartRepository()) {
        self.repository = repository
    }

    var items: [CartItem] { repository.items }

    var totalPrice: Double {
        repository.items.reduce(0) { $0 + $1.subtotal }
    }

    var totalItems: Int {
        repository.items.reduce(0) { $0 + $1.quantity }
    }

    var isEmpty: Bool {
        repository.items.isEmpty
    }

    // Business logic lives here — e.g. stock checks, max quantity rules
    func addToCart(product: Product) {
        guard product.stock > 0 else {
            print("⚠️ \(product.title) is out of stock")
            return
        }
        repository.add(product: product)
    }

    func removeFromCart(product: Product) {
        repository.remove(product: product)
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard newQuantity <= item.product.stock else {
            print("⚠️ Quantity exceeds available stock")
            return
        }
        repository.updateQuantity(for: item, newQuantity: newQuantity)
    }

    func clearCart() {
        repository.clear()
    }
}
