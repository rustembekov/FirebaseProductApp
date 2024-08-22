//
//  FavoritesViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 16.08.2024.
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()

    func getFromUserFavoriteProductsListener() throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
        UserManager.shared.addUserFavoriteProductListener(userId: authDataResult.uid)
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] userFavoriteProducts in
                self?.userFavoriteProducts = userFavoriteProducts
            }
            .store(in: &cancellables)
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
