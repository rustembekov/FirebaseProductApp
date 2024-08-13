//
//  AuthenticationManager.swift
//  FirebasePractice
//
//  Created by Sabr on 27.07.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

final class AuthenticationManager {
   static var shared = AuthenticationManager()
    
    func getAuthenticationUser() throws -> AuthDataModel {
        guard let currentUser = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataModel(user: currentUser)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        try await user.delete()
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.cannotLoadFromNetwork)
        }
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option doesn't found: \(provider.providerID)")
            }
            
        }
        return providers
    }
}



//MARK: Email Sign In
extension AuthenticationManager {
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataModel {
        let authDataUser = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataModel(user: authDataUser.user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataModel {
        let authDataUser = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataModel(user: authDataUser.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword() throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        user.updatePassword(to: "1")
    }
}


//MARK: Google Sign In
extension AuthenticationManager {

    @discardableResult
    func signInGoogle(tokens: GoogleSignInTokens) async throws -> AuthDataModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInCredential(credential: credential)
    }
    
    @discardableResult
    func signInApple(tokens: AppleSignInTokens) async throws -> AuthDataModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.appleIDToken, rawNonce: tokens.nonce)
        return try await signInCredential(credential: credential)
    }
    
    func signInCredential(credential: AuthCredential) async throws -> AuthDataModel {
        let authUserResult = try await Auth.auth().signIn(with: credential)
        return AuthDataModel(user: authUserResult.user)
    }
}


//MARK: Anonymously Sign in
extension AuthenticationManager {
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataModel {
        let authUserResult = try await Auth.auth().signInAnonymously()
        return AuthDataModel(user: authUserResult.user)
    }
    
    @discardableResult
    func linkGoogleAnonymously(tokens: GoogleSignInTokens) async throws -> AuthDataModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredentialAnonymously(credential: credential)
    }
    
    @discardableResult
    func linkAppleAnonymously(tokens: AppleSignInTokens) async throws -> AuthDataModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.appleIDToken, rawNonce: tokens.nonce)
        return try await linkCredentialAnonymously(credential: credential)
    }
    
    @discardableResult
    func linkEmailAnonymously(email: String, password: String) async throws -> AuthDataModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredentialAnonymously(credential: credential)
    }
    
    func linkCredentialAnonymously(credential: AuthCredential) async throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        let authDataResult = try await user.link(with: credential)
        return AuthDataModel(user: authDataResult.user)
    }
    
}
