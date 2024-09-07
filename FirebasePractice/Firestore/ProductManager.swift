//
//  ProductManager.swift
//  FirebasePractice
//
//  Created by Sabr on 09.08.2024.
//

import Foundation
import FirebaseFirestore

final class ProductManager {
    static let shared = ProductManager()

    private let productsCollection = Firestore.firestore().collection("products")

    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func createProduct(product: Product) throws {
        try productDocument(productId: "\(product.id)").setData(from: product, merge: false)
    }
    
    private func getAllProductsQuery() -> Query {
        return productsCollection
    }
    
    private func getProductsByPriceQuery(descending: Bool) -> Query {
        productsCollection.order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getProductsByCategoryQuery(option: String) -> Query {
        productsCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
    }
    
    private func getProductsByRatingQuery() -> Query {
        productsCollection.order(by: Product.CodingKeys.rating.rawValue, descending: true)
    }
    
    private func getProductsPriceAndCategoryQuery(option: String, descending: Bool) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getProductsRatingAndCategoryQuery(option: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: option)
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
    }
    
    func getAllProductsQuery(forPriceAndRankFilter filter: ProductsViewModel.SortingByPriceAndRating?, forCategoryFilter option: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> ([Product], DocumentSnapshot?) {
        var query: Query = self.getAllProductsQuery()
        
        if let filter = filter {
            switch filter {
            case .rating:
                if let option = option {
                    query = self.getProductsRatingAndCategoryQuery(option: option)
                } else {
                    query = self.getProductsByRatingQuery()
                }
            case .descending, .ascending:
                let descending = (filter == .descending)
                if let option = option {
                    query = self.getProductsPriceAndCategoryQuery(option: option, descending: descending)
                } else {
                    query = self.getProductsByPriceQuery(descending: descending)
                }
            }
        } else if let option = option {
            query = self.getProductsByCategoryQuery(option: option)
        }
        query = query.startFromLast(afterDocument: lastDocument)

        return try await query
            .limit(to: count)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
//    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
//        if let lastDocument {
//            return try await productsCollection
//                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .startFromLast(afterDocument: lastDocument)
//                .getDocumentsWithSnapshot(as: Product.self)
//        } else {
//            return try await productsCollection
//                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .getDocumentsWithSnapshot(as: Product.self)
//        }
//    }
    
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection
            .limit(to: 5)
            .getDocuments(as: Product.self)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
        
    }
    
    //MARK: Get Products by async
    /*
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
    */
    
    
}

enum FilterByPrice: String,CaseIterable {
    case ascending = "Ascending by price"
    case descending = "Descending by price"
}

