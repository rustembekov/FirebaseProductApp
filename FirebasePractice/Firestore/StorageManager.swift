//
//  StorageManager.swift
//  FirebasePractice
//
//  Created by Sabr on 27.08.2024.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    private let storage = Storage.storage().reference()

    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReferenceToImages(userId: String) -> StorageReference {
        imagesReference.child("users").child(userId)
    }
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedStorageMetadata = try await userReferenceToImages(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedStorageMetadata.path, let returnedName = returnedStorageMetadata.name else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return (returnedPath, returnedName)
    }
    
    func getImagePath(userProfileImagePath: String) -> StorageReference {
        Storage.storage().reference(withPath: userProfileImagePath)
    }
    
    func getImageUrl(userProfileImagePath: String) async throws -> URL {
        try await getImagePath(userProfileImagePath: userProfileImagePath).downloadURL()
    }
    
    func deleteImage(userProfileImagePath: String) async throws {
        try await getImagePath(userProfileImagePath: userProfileImagePath).delete()
    }
    
//    func saveImage(image: UIImage) async throws -> (path: String, name: String) {
//        guard let data = image.jpegData(compressionQuality: 1) else {
//            throw URLError(.backgroundSessionWasDisconnected)
//        }
//
//        return try await saveImage(data: data)
//    }
}
