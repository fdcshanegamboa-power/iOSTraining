//
//  CartService.swift
//  iOSTraining
//

import Foundation

protocol CartServiceProtocol {
    func toggleSelection(for item: CartItem)
    func toggleSelectAll()
    func checkout()
}

final class CartService: CartServiceProtocol {
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol = CartRepository()) {
        self.repository = repository
    }
    
    func toggleSelection(for item: CartItem) {
        repository.toggleSelection(for: item)
    }
    
    func toggleSelectAll() {
        if repository.allSelected {
            repository.deselectAll()
        } else {
            repository.selectAll()
        }
    }
    
    func checkout() {
        guard repository.hasSelectedItems else { return }
        
        let selectedItems = repository.selectedItems
        let total = repository.selectedTotalPrice
        
        print("✅ Checkout Successful!")
        print("Items purchased: \(selectedItems.count)")
        print("Total amount: $\(String(format: "%.2f", total))")
        print("---")
        selectedItems.forEach { item in
            print("- \(item.product.title) x\(item.quantity)")
        }
        
        repository.removeSelected()
    }
}
