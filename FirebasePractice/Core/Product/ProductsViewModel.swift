//
//  ProductsViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 09.08.2024.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilterByPrice: SortingByPriceAndRating? = nil
    @Published var selectedCategory: Category? = nil
    private var lastDocument: DocumentSnapshot? = nil

    enum SortingByPriceAndRating: String, CaseIterable {
        case rating = "By rating"
        case ascending = "Ascending by price"
        case descending = "Descending by price"
    }

    
    enum Category: String, CaseIterable {
        case groceries, furniture, fragrances, beauty, ALL
        
        var categoryName: String? {
            if self == .ALL {
                return nil
            }
            return self.rawValue
        }
    }

    func getProductsByPriceAndRating(option: SortingByPriceAndRating) {
        self.selectedFilterByPrice = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProductsByCategory(option: Category) {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductManager.shared.getAllProductsQuery(forPriceAndRankFilter: self.selectedFilterByPrice, forCategoryFilter: self.selectedCategory?.categoryName, count: 5, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
            try? await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
    
    
    //MARK: For downloading data
    /*
    func uploadProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let productArray = try JSONDecoder().decode(ProductArray.self, from: data)
                for product in productArray.products {
                    try ProductManager.shared.createProduct(product: product)
                }
                print("Successfully uploaded")
                print(productArray.products.count)
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
     */
}
