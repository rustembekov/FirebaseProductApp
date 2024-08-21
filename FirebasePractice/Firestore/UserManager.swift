//
//  UserManager.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let movies: Movie?
    
    init(authUser: AuthDataModel) {
        self.userId = authUser.uid
        self.isAnonymous = authUser.isAnonymous
        self.email = authUser.email
        self.photoUrl = authUser.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.movies = nil
    }
    
    init(userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        movies: Movie? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.movies = movies
    }
    
    enum CodingKeys: String , CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonynmous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case preferences = "preferences"
        case movies = "movies"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.movies = try container.decodeIfPresent(Movie.self, forKey: .movies)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.movies, forKey: .movies)
    }
    
    
    
    
//    func updateUserPremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated, isPremium: !currentValue)
//    }
//    mutating func updateUserPremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//
//    }
}

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private func userFavoriteProductCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_product")
    }
    private func userFavoriteProductDocument(userId: String, productId: String) -> DocumentReference {
        userFavoriteProductCollection(userId: userId).document(productId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
     
    func createUser(user: DBUser) throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserProfile(isPremium: Bool, userId: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreferences(preference: String, userId: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayUnion([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }

    func removeUserPreferences(preference: String, userId: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayRemove([preference])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserMovie(movie: Movie, userId: String) async throws {
        let data = try encoder.encode(movie)
        let dict: [String: Any] = [
            DBUser.CodingKeys.movies.rawValue: data
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeUserMovie(userId: String) async throws {
        let data: [String: Any?] = [
            DBUser.CodingKeys.movies.rawValue: nil
        ]
        try await userDocument(userId: userId).updateData(data as [AnyHashable: Any])
    }
    
    func addUserFavoriteProductListener(userId: String, completion: @escaping(_ products: [UserFavoriteProduct]) -> ()) {
        userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching snapshots: \(error)") 
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self )})
            completion(products)
        }
    }
    
    func addUserFavoriteProduct(userId: String, productId: Int) async throws {
        let userFavoritesCollection = userDocument(userId: userId).collection("favorite_product").document()
        let documentId = userFavoritesCollection.documentID

        let data: [String: Any] = [
            UserFavoriteProduct.CodingKeys.id.rawValue: documentId,
            UserFavoriteProduct.CodingKeys.productId.rawValue: productId,
            UserFavoriteProduct.CodingKeys.dateCreated.rawValue: Date()
        ]
        try await userFavoritesCollection.setData(data, merge: false)
    }

    func removeUserFavoriteProduct(userId: String, productId: String) {
        userFavoriteProductDocument(userId: userId, productId: productId).delete()
    }
    
    func getAllFavoriteProducts(userId: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userId: userId).getDocuments(as: UserFavoriteProduct.self)
    }

}


struct UserFavoriteProduct: Identifiable, Codable {
    let id: String
    let productId: Int
    let dateCreated: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
}
