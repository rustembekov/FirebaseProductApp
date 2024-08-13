//
//  AppleSignInHelper.swift
//  FirebasePractice
//
//  Created by Sabr on 31.07.2024.
//

import Foundation
import CryptoKit
import AuthenticationServices
import SwiftUI

struct AppleSignInTokens {
    let nonce: String
    let appleIDToken: String
}

struct SignInWithAppleButtonUIViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

@MainActor
final class AppleSignInHelper: NSObject {
    private var currentNonce: String?
    private var completionHandler: ((Result<AppleSignInTokens, Error>) -> Void)? = nil

    func startSignInWithAppleFlow() async throws -> AppleSignInTokens {
        try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInAppleTokens):
                    continuation.resume(returning: signInAppleTokens)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func startSignInWithAppleFlow(completion: @escaping(Result<AppleSignInTokens, Error>) -> ()) {
        guard let topVC = ViewController.shared.topViewController() else {
            completion(.failure(URLError(.cannotFindHost)))
            return
        }
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }

    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}


extension AppleSignInHelper: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce else {
            completionHandler?(.failure(URLError(.cannotFindHost)))
            return
        }
        
        let tokens = AppleSignInTokens(nonce: nonce, appleIDToken: idTokenString)
        completionHandler?(.success(tokens))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
    }
    
}


extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
