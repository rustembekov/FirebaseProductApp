//
//  Query.swift
//  FirebasePractice
//
//  Created by Sabr on 14.08.2024.
//

import Foundation
import FirebaseFirestore
import Combine

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T] , lastElement: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        let products = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return (products, snapshot.documents.last)
    }
    
    func startFromLast(afterDocument lastElement: DocumentSnapshot?) -> Query {
        guard let lastElement else { return self }
        return self.start(afterDocument: lastElement)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T: Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents found!")
                return
            }
            
            let products: [T] = documents.compactMap { try? $0.data(as: T.self)}
            publisher.send(products)
        }
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}
