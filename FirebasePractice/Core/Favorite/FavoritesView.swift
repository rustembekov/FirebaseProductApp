//
//  FavoritesView.swift
//  FirebasePractice
//
//  Created by Sabr on 15.08.2024.
//

import SwiftUI

@MainActor
class FavoritsesViewModel: ObservableObject {
    
    func getFavoriteProducts() {
        
    }
}

struct FavoritesView: View {
    @StateObject private var vm = FavoritsesViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
