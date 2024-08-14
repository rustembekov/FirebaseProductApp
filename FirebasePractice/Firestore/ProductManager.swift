//
//  ProductManager.swift
//  FirebasePractice
//
//  Created by Sabr on 09.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductManager {
    static let shared = ProductManager()

    private let productsCollection = Firestore.firestore().collection("products")

    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func createProduct(product: Product) throws {
        try productDocument(productId: "\(product.id)").setData(from: product, merge: false)
    }
    
    private func getAllProducts() -> Query {
        return productsCollection
    }
    
    private func getProductsByPrice(descending: Bool) -> Query {
        return productsCollection.order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getProductsByCategory(option: String) -> Query {
        return productsCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
    }
    
    private func getProductsPriceAndCategory(option: String, descending: Bool) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    func getAllProducts(forPriceFilter descending: Bool?, forCategoryFilter option: String?) -> Query {
        if let descending, let option {
            return self.getProductsPriceAndCategory(option: option, descending: descending)
        } else if let option {
            return self.getProductsByCategory(option: option)
        } else if let descending {
            return self.getProductsByPrice(descending: descending)
        }
        return self.getAllProducts()
    }
    
     
    
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection
            .limit(to: 5)
            .getDocuments(as: Product.self)
    }
    
    private func getProductsByPrice(descending: Bool) async throws -> [Product] {
        try await productsCollection.order(by: "price", descending: descending).getDocuments(as: Product.self)
    }
    
    private func getProductsByCategory(option: String) async throws -> [Product] {
        try await productsCollection.whereField("category", isEqualTo: option).getDocuments(as: Product.self)
    }
    
    private func getAllProductsPriceAndCategory(descending: Bool, option: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocuments(as: Product.self)
    }
    
    func getAllProducts(forPriceFilter descending: Bool?, forCategoryFilter option: String?) async throws -> [Product] {
        if let descending, let option {
            return try await self.getAllProductsPriceAndCategory(descending: descending, option: option)
        } else if let descending {
            return try await self.getProductsByPrice(descending: descending)
        } else if let option {
            return try await self.getProductsByCategory(option: option)
        }
        return try await self.getAllProducts()
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
}

enum FilterByPrice: String,CaseIterable {
    case ascending = "Ascending by price"
    case descending = "Descending by price"
}

