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
    
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection
            .getProducts(as: Product.self)
    }
    
    private func getProductsByPrice(descending: Bool) async throws -> [Product] {
        try await productsCollection.order(by: "price", descending: descending).getProducts(as: Product.self)
    }
    
    private func getProductsByCategory(option: String) async throws -> [Product] {
        try await productsCollection.whereField("category", isEqualTo: option).getProducts(as: Product.self)
    }
    
    private func getAllProductsPriceAndCategory(descending: Bool, option: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getProducts(as: Product.self)
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

extension Query {
    func getProducts<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
    }
    
    
}
