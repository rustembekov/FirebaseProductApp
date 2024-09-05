//
//  ProfileView.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedPhotosPickerItem: PhotosPickerItem? = nil
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]

    private func preferenceIsSelected(text: String) -> Bool {
        vm.self.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = vm.user {
                Text("User ID: \(user.userId)")
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    vm.togglePremiumStatus()
                } label: {
                    Text("User is premium \((user.isPremium ?? false).description.capitalized)")
                }
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { option in
                            Button(option) {
                                if preferenceIsSelected(text: option) {
                                    vm.removeUserPreference(text: option)
                                }
                                else {
                                    vm.addUserPreference(text: option)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .font(.headline)
                            .tint(preferenceIsSelected(text: option) ? .green : .red)
                        }
                    }
                    
                    if let preferences = user.preferences, !preferences.isEmpty {
                        Text("User preferences: \(preferences.joined(separator: ", "))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("User preferences: No preferences set")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Button {
                    if user.movies == nil {
                        vm.addUserMovie()
                    } else {
                        vm.removeUserMovie()
                    }
                } label: {
                    Text("User is movie: \(user.movies?.title ?? "None")")
                }
                
                PhotosPicker(selection: $selectedPhotosPickerItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a image")
                }
                
                if let urlString = vm.user?.profileImagePathUrl, let url = URL(string: urlString)  {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
                
                if vm.user?.profileImagePath != nil {
                    Button("Delete image") {
                        vm.deleteImage()
                    }
                }

                
            } else {
                Text("Loading user data...")
            }
        }
        .task {
            try? await vm.loadCurrentUser()
        }
        .onChange(of: selectedPhotosPickerItem, perform: { newValue in
            if let newValue {
                vm.saveImage(item: newValue)
            }
        })
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView(showSignInView: $showSignInView), label: {
                    Image(systemName: "gear")
                        .font(.headline)
                })
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
       RootView()
    }
}
