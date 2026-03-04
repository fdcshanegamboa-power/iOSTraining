//
//  NetworkManager.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import Foundation

// MARK: - Protocol
protocol ProductFetchDelegate: AnyObject {
    func didFetchProducts(_ products: [Product])
    func didFailWithError(_ error: Error)
}

// MARK: - NetworkManager
class NetworkManager {
    static let shared = NetworkManager()
    
    private let productsURL = "https://dummyjson.com/products?limit=100"
    
    weak var delegate: ProductFetchDelegate?
    
    private init() {}
    
    func fetchProducts() {
        guard let url = URL(string: productsURL) else {
            let error = NSError(
                domain: "NetworkManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
            )
            delegate?.didFailWithError(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    self?.delegate?.didFailWithError(error)
                }
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(
                    domain: "NetworkManager",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]
                )
                DispatchQueue.main.async {
                    self?.delegate?.didFailWithError(error)
                }
                return
            }
            
            // Decode data
            guard let data = data else {
                let error = NSError(
                    domain: "NetworkManager",
                    code: -3,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"]
                )
                DispatchQueue.main.async {
                    self?.delegate?.didFailWithError(error)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let productResponse = try decoder.decode(ProductResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.delegate?.didFetchProducts(productResponse.products)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.delegate?.didFailWithError(error)
                }
            }
        }
        
        task.resume()
    }
}
