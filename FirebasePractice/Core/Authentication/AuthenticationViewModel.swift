//
//  AuthenticationViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInApple() async throws {
        let helper = AppleSignInHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInApple(tokens: tokens)
        try UserManager.shared.createUser(user: DBUser(authUser: authDataResult))
    }
    
    func signInGoogle() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signInGoogle()
        let authDataResult = try await AuthenticationManager.shared.signInGoogle(tokens: tokens)
        try UserManager.shared.createUser(user: DBUser(authUser: authDataResult))
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
        try UserManager.shared.createUser(user: DBUser(authUser: authDataResult))
    }
    
    
}
