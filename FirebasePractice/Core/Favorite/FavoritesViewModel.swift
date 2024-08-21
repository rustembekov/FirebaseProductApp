//
//  FavoritesViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 16.08.2024.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    

    func getFromUserFavoriteProductsListener() throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
        UserManager.shared.addUserFavoriteProductListener(userId: authDataResult.uid) { products in
            self.userFavoriteProducts = products
        }
    }
    
//    func getFavoriteProducts() {
//        Task {
//            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
//            self.userFavoriteProducts = try await UserManager.shared.getAllFavoriteProducts(userId: authDataResult.uid)
//            print("User Favorite Products: \(userFavoriteProducts)")
//        }
//    }
    
    func removeFavoriteProducts(productId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
            UserManager.shared.removeUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
            try? self.getFromUserFavoriteProductsListener()
        }
    }
}
