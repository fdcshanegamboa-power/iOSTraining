//
//  CartRepository.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/2/26.
// Cart/Repository/CartRepository.swift

import Foundation

protocol CartRepositoryProtocol {
    var items: [CartItem] { get }
    func add(product: Product)
    func remove(product: Product)
    func updateQuantity(for item: CartItem, newQuantity: Int)
    func clear()
}

final class CartRepository: CartRepositoryProtocol {
    private let manager = CartManager.shared

    var items: [CartItem] { manager.items }

    func add(product: Product) {
        manager.add(product: product)
    }

    func remove(product: Product) {
        manager.remove(product: product)
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        manager.updateQuantity(for: item, newQuantity: newQuantity)
    }

    func clear() {
        manager.clear()
    }
}
