//
//  Product.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let thumbnail: String
    let images: [String]
    
    // Convenience computed property
    var image: String? {
        return images.first
    }
}

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}
