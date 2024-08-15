//
//  ProductsView.swift
//  FirebasePractice
//
//  Created by Sabr on 09.08.2024.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var vm = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(vm.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                        Button("Add to favorites") {
                            vm.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                if product == vm.products.last {
                    ProgressView()
                        .onAppear {
                            vm.getProducts()
                        }
                }
            }
        }
        .onAppear {
            vm.getProducts()
        }
        .navigationBarTitle("Products")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    ForEach(ProductsViewModel.SortingByPriceAndRating.allCases, id: \.self) { option in
                        Button(option.rawValue.capitalized) {
                            vm.getProductsByPriceAndRating(option: option)
                        }
                    }
                } label: {
                    Text("Price")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(ProductsViewModel.Category.allCases, id: \.self) { option in
                        Button(option.categoryName?.capitalized ?? "All products") {
                            vm.getProductsByCategory(option: option)
                        }
                    }
                } label: {
                    Text("Category")
                }

            }
        }

    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
