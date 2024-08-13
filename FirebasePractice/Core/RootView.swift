//
//  RootView.swift
//  FirebasePractice
//
//  Created by Sabr on 27.07.2024.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProductsView()
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticationUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignIn: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
