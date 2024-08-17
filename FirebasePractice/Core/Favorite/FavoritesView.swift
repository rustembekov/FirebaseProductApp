//
//  FavoritesView.swift
//  FirebasePractice
//
//  Created by Sabr on 15.08.2024.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var vm = FavoritesViewModel()
    
    var body: some View {
        List {
            ForEach(vm.userFavoriteProducts) { product in
                ProductCellBuilderView(productId: String(product.productId))
                    .contextMenu {
                        Button("Remove Favorite Product") {
                            vm.removeFavoriteProducts(productId: product.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorite Products")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
