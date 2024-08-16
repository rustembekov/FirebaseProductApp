//
//  ProductCellBuilderView.swift
//  FirebasePractice
//
//  Created by Sabr on 16.08.2024.
//

import SwiftUI

struct ProductCellBuilderView: View {
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductManager.shared.getProduct(productId: productId)
        }
    }
}

struct ProductCellBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellBuilderView(productId: "1")
    }
}
