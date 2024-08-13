//
//  GoogleSignInHelper.swift
//  FirebasePractice
//
//  Created by Sabr on 31.07.2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInTokens {
    let accessToken: String
    let idToken: String
}

final class GoogleSignInHelper {
    
    @MainActor
    func signInGoogle() async throws -> GoogleSignInTokens {
        guard let topVC = ViewController.shared.topViewController() else {
            throw URLError(.cannotLoadFromNetwork)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard
            let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.cannotFindHost)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let tokens = GoogleSignInTokens(accessToken: accessToken, idToken: idToken)
        return tokens
    }

}
