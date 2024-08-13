//
//  ProductsViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 09.08.2024.
//

import Foundation



@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilterByPrice: SortingByPrice? = nil
    @Published var selectedCategory: Category? = nil
    
    enum SortingByPrice: String, CaseIterable {
        case ascending = "Ascending by price"
        case descending = "Descending by price"
        
        var sortDescending: Bool {
            switch self {
                case .ascending:
                    return true
                case .descending:
                    return false
            }
        }
    }
    
    enum Category: CaseIterable {
        case groceries, furniture, fragrances, beauty

        var name: String {
            switch self {
            case .groceries:
                return "groceries"
            case .furniture:
                return "furniture"
            case .fragrances:
                return "fragrances"
            case .beauty:
                return "beauty"
            }
        }
    }

    func getProductsByPrice(option: SortingByPrice) {
        self.selectedFilterByPrice = option
        self.products = []
        self.getProducts()
    }
    
    func getProductsByCategory(option: Category) {
        self.selectedCategory = option
        self.products = []
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductManager.shared.getAllProducts(forPriceFilter: self.selectedFilterByPrice?.sortDescending, forCategoryFilter: self.selectedCategory?.name)
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
