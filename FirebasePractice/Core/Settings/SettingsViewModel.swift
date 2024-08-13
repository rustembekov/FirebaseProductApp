//
//  SettingsViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var providersAuthUser: [AuthProviderOption] = []
    @Published var authUser: AuthDataModel? = nil
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func reset() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticationUser()
        guard let email = authUser.email else {
            throw URLError(.cannotLoadFromNetwork)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func delete() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func loadUser() {
        do {
            try self.authUser = AuthenticationManager.shared.getAuthenticationUser()

        } catch  {
            print("Error \(error)")
        }
    }
    
    func loadProviders() {
        do {
            providersAuthUser = try AuthenticationManager.shared.getProviders()
        } catch {
            print("Error \(error)")
        }
        
    }
    func linkGoogleAccount() async throws {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signInGoogle()
        self.authUser = try await AuthenticationManager.shared.linkGoogleAnonymously(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = AppleSignInHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkAppleAnonymously(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        self.authUser = try await AuthenticationManager.shared.linkEmailAnonymously(email: "Hello3@tesing.com", password: "qwertyuiop")
    }
}
