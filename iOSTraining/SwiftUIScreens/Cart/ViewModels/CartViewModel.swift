// Cart/ViewModel/CartViewModel.swift

import Foundation
import Observation

@Observable
final class CartViewModel {
    private let service: CartServiceProtocol
    var showingCheckoutAlert = false

    init(service: CartServiceProtocol = CartService()) {
        self.service = service
    }

    var items: [CartItem] { service.items }
    var totalPrice: Double { service.totalPrice }
    var totalItems: Int { service.totalItems }
    var isEmpty: Bool { service.isEmpty }

    func removeItem(_ item: CartItem) {
        service.removeFromCart(product: item.product)
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        service.updateQuantity(for: item, newQuantity: newQuantity)
    }

    func checkout() {
        showingCheckoutAlert = true
    }
}
