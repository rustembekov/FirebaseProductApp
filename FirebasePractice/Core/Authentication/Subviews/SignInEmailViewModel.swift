//
//  SignInEmailViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation

class SignInEmailViewModel: ObservableObject {
    let manager = AuthenticationManager.shared
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else  {
            print("No email or password!")
            return
        }
        let authDataResult =  try await manager.createUser(email: email, password: password)
        try UserManager.shared.createUser(user: DBUser(authUser: authDataResult))

    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else  {
            print("No email or password!")
            return
        }
       try await manager.signIn(email: email, password: password)

    }
    
}
