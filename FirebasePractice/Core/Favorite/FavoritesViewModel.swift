//
//  FavoritesViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 16.08.2024.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [UserFavoriteProduct] = []
    
    func getFavoriteProducts() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
            print("AuthenticationManager User ID: \(authDataResult.uid)")
            self.favoriteProducts = try await UserManager.shared.getAllFavoriteProducts(userId: authDataResult.uid)
            print("AuthenticationManager Products: \(favoriteProducts)")

        }
    }
    
    func removeFavoriteProducts(productId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
            UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
}
