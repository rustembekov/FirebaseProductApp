//
//  Query.swift
//  FirebasePractice
//
//  Created by Sabr on 14.08.2024.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
    }
    
    func getDocumentsWithSnapshot(){
        
    }
}
