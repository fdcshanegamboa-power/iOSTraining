//
//  CartRepository.swift
//  iOSTraining
//

import Foundation

protocol CartRepositoryProtocol {
    var items: [CartItem] { get }
    var selectedItems: [CartItem] { get }
    var selectedTotalPrice: Double { get }
    var hasSelectedItems: Bool { get }
    var allSelected: Bool { get }
    
    func add(product: Product)
    func remove(product: Product)
    func removeSelected()
    func updateQuantity(for item: CartItem, newQuantity: Int)
    func toggleSelection(for item: CartItem)
    func selectAll()
    func deselectAll()
    func clear()
}

final class CartRepository: CartRepositoryProtocol {
    private let manager = CartManager.shared

    var items: [CartItem] { manager.items }
    var selectedItems: [CartItem] { manager.selectedItems }
    var selectedTotalPrice: Double { manager.selectedTotalPrice }
    var hasSelectedItems: Bool { manager.hasSelectedItems }
    var allSelected: Bool { manager.allSelected }

    func add(product: Product) {
        manager.add(product: product)
    }

    func remove(product: Product) {
        manager.remove(product: product)
    }
    
    func removeSelected() {
        manager.removeSelected()
    }

    func updateQuantity(for item: CartItem, newQuantity: Int) {
        manager.updateQuantity(for: item, newQuantity: newQuantity)
    }
    
    func toggleSelection(for item: CartItem) {
        manager.toggleSelection(for: item)
    }
    
    func selectAll() {
        manager.selectAll()
    }
    
    func deselectAll() {
        manager.deselectAll()
    }

    func clear() {
        manager.clear()
    }
}
