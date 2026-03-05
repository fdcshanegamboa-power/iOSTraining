//
//  FlashSaleService.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/4/26.
//

import Foundation
import Observation

struct FlashSaleItem: Identifiable, Equatable {
    let id: Int
    let product: Product
    let flashPrice: Double
    let discountPercent: Int
    let originalPrice: Double

    static func == (lhs: FlashSaleItem, rhs: FlashSaleItem) -> Bool {
        lhs.id == rhs.id
    }
}


struct FlashSaleConfig {
    static let cycleDuration: TimeInterval = 35
    static let saleDuration: TimeInterval = 30
    static let productCount: Int = 10
    static let discountMultiplier: Double = 0.60
}

@Observable
final class FlashSaleService {
    static let shared = FlashSaleService()

    // MARK: Published state
    private(set) var currentFlashItems: [FlashSaleItem] = []

    // MARK: Persistence keys
    private enum Keys {
        static let saleStartDate  = "flashSale_startDate"
        static let saleEndDate    = "flashSale_endDate"
        static let productSeed    = "flashSale_productSeed"
    }

    private let defaults = UserDefaults.standard
    
    private init() {}

    func currentSaleWindow() -> (start: Date, end: Date) {
        // Restore persisted window
        if let start = defaults.object(forKey: Keys.saleStartDate) as? Date,
           let end   = defaults.object(forKey: Keys.saleEndDate) as? Date,
           end > Date() {
            return (start, end)
        }
        return createNewCycle()
    }
    func isSaleActive(in window: (start: Date, end: Date)) -> Bool {
        let elapsed = Date().timeIntervalSince(window.start)
        return elapsed >= 0 && elapsed < FlashSaleConfig.saleDuration
    }

    func secondsRemaining(in window: (start: Date, end: Date)) -> TimeInterval {
        let now = Date()
        if isSaleActive(in: window) {
            // Time left in the sale
            return window.start.addingTimeInterval(FlashSaleConfig.saleDuration).timeIntervalSince(now)
        } else {
            // Time until the NEXT sale starts
            return window.end.timeIntervalSince(now)
        }
    }

    @discardableResult
    func createNewCycle() -> (start: Date, end: Date) {
        let start = Date()
        let end   = start.addingTimeInterval(FlashSaleConfig.cycleDuration)
        defaults.set(start, forKey: Keys.saleStartDate)
        defaults.set(end,   forKey: Keys.saleEndDate)
        // New random seed so we get different products each cycle
        defaults.set(Int.random(in: 0..<Int.max), forKey: Keys.productSeed)
        return (start, end)
    }

    /// Selects flash-sale items from the full product catalogue.
    ///
    /// Selection strategy (layered):
    ///   1. Prefer products with rating ≥ 4.5  (quality signal)
    ///   2. Among those, prefer low-stock items (scarcity signal)
    ///   3. Shuffle with a persisted seed so the batch stays stable
    ///      within a cycle but changes between cycles.
    func selectFlashItems(from products: [Product]) -> [FlashSaleItem] {
        guard !products.isEmpty else { 
            currentFlashItems = []
            return [] 
        }

        let seed = defaults.integer(forKey: Keys.productSeed)

        // 1. High-rated pool
        let highRated = products.filter { $0.rating >= 4.5 }
        let pool      = highRated.count >= FlashSaleConfig.productCount ? highRated : products

        // 2. Sort by stock ascending (scarcity), then shuffle deterministically
        let sorted    = pool.sorted { $0.stock < $1.stock }
        let shuffled  = sorted.deterministicShuffle(seed: seed)
        let selected  = Array(shuffled.prefix(FlashSaleConfig.productCount))

        // 3. Build FlashSaleItem with discount applied
        let items = selected.map { makeFlashItem(from: $0) }
        currentFlashItems = items
        return items
    }
    
    /// Clears current flash items (called when sale ends)
    func clearFlashItems() {
        print("🧹 Clearing flash sale items (count: \(currentFlashItems.count))")
        currentFlashItems = []
    }

    // MARK: - Private helpers

    private func makeFlashItem(from product: Product) -> FlashSaleItem {
        let flashPrice      = (product.price * FlashSaleConfig.discountMultiplier * 100).rounded() / 100
        let savedPercent    = Int(((product.price - flashPrice) / product.price) * 100)
        return FlashSaleItem(
            id:              product.id,
            product:         product,
            flashPrice:      flashPrice,
            discountPercent: savedPercent,
            originalPrice:   product.price
        )
    }
}

// MARK: - Array + Deterministic Shuffle

private extension Array {
    /// Shuffles using a simple seeded LCG so the result is stable for a given seed.
    func deterministicShuffle(seed: Int) -> [Element] {
        var result = self
        var rng    = SeededRNG(seed: seed)
        for i in stride(from: result.count - 1, through: 1, by: -1) {
            let j = rng.next() % (i + 1)
            result.swapAt(i, j)
        }
        return result
    }
}

private struct SeededRNG {
    private var state: Int

    init(seed: Int) { state = seed == 0 ? 1 : seed }

    mutating func next() -> Int {
        // Linear Congruential Generator constants (Numerical Recipes)
        state = state &* 1664525 &+ 1013904223
        return abs(state)
    }
}
