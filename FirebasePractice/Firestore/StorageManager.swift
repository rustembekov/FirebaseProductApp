//
//  StorageManager.swift
//  FirebasePractice
//
//  Created by Sabr on 27.08.2024.
//

import Foundation
import FirebaseStorage
import Photos

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    private let storage = Storage.storage().reference()

    func saveImage(data: Data) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedStorageMetadata = try await storage.child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedStorageMetadata.path, let returnedName = returnedStorageMetadata.name else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        

        return (returnedPath, returnedName)
    }
    
//    func saveImage(image: UIImage) async throws -> (path: String, name: String) {
//        guard let data = image.jpegData(compressionQuality: 1) else {
//            throw URLError(.backgroundSessionWasDisconnected)
//        }
//
//        return try await saveImage(data: data)
//    }
}
