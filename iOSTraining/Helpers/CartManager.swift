//
//  CartManager.swift
//  iOSTraining
//

import Foundation
import Observation

@Observable
class CartManager {
    static let shared = CartManager()

    private let defaults = UserDefaults.standard
    private let cartKey = "saved_cart_items"
    
    private init(){
        self.items = load()
    }

    private(set) var items: [CartItem] = []
    
    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1, isSelected: false))
        }
        save()
    }

    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
        save()
    }
    
    func removeSelected() {
        items.removeAll { $0.isSelected }
        save()
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if newQuantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = newQuantity
        }
        save()
    }
    
    func toggleSelection(for item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isSelected.toggle()
        save()
    }
    
    func selectAll() {
        for index in items.indices {
            items[index].isSelected = true
        }
        save()
    }
    
    func deselectAll() {
        for index in items.indices {
            items[index].isSelected = false
        }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var selectedItems: [CartItem] {
        items.filter { $0.isSelected }
    }
    
    var selectedTotalItems: Int {
        selectedItems.reduce(0) { $0 + $1.quantity }
    }
    
    var selectedTotalPrice: Double {
        selectedItems.reduce(0) { $0 + $1.subtotal }
    }
    
    var hasSelectedItems: Bool {
        items.contains { $0.isSelected }
    }
    
    var allSelected: Bool {
        !items.isEmpty && items.allSatisfy { $0.isSelected }
    }

    var isEmpty: Bool {
        items.isEmpty
    }
    
    private func load() -> [CartItem] {
        guard let data = defaults.data(forKey: cartKey) else { return [] }
        return (try? JSONDecoder().decode([CartItem].self, from: data)) ?? []
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: cartKey)
        }
    }
}
