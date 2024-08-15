//
//  FavoritesView.swift
//  FirebasePractice
//
//  Created by Sabr on 15.08.2024.
//

import SwiftUI

@MainActor
class FavoritsesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    func getFavoriteProducts() {
        
    }
}

struct FavoritesView: View {
    @StateObject private var vm = FavoritsesViewModel()
    
    var body: some View {
        List {
            ForEach(vm.favoriteProducts) { product in
               ProductCellView(product: product)
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
