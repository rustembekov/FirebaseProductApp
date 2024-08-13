//
//  AuthenticationView.swift
//  FirebasePractice
//
//  Created by Sabr on 26.07.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices

struct AuthenticationView: View {
    @StateObject private var vm = AuthenticationViewModel()
    @Binding var showSignIn: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    try await vm.signInAnonymously()
                    showSignIn = false
                }
            }, label: {
                Text("Sign In Anonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            })
            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignIn)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    try await vm.signInGoogle()
                    showSignIn = false
                }
            }
            Button(action: {
                Task {
                    do {
                        try await vm.signInApple()
                        showSignIn = false
                    } catch {
                        print("Error apple: \(error)")
                    }
                    
                }
            }, label: {
                SignInWithAppleButtonUIViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            })
            .frame(height: 55)



        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignIn: .constant(true))
        }
    }
}
