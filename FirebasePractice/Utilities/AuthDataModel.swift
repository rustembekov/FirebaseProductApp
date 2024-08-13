//
//  AuthDataModel.swift
//  FirebasePractice
//
//  Created by Sabr on 27.07.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}
