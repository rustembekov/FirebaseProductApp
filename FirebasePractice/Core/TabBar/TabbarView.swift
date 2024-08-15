//
//  TabbarView.swift
//  FirebasePractice
//
//  Created by Sabr on 15.08.2024.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductsView()
            }
            .tabItem {
                Image(systemName: "cart")
                Text("Products")
            }
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(false))
    }
}
