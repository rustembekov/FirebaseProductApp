//
//  ProfileViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticationUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("User ID: \(user?.userId ?? "None")")
    }
    
    func togglePremiumStatus() {
        guard let user = user else { return }
        let currentValue = user.isPremium ?? false

        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                try await UserManager.shared.updateUserProfile(isPremium: !currentValue, userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Failed to update premium status: \(error)")
            }
        }
    }

    
    func addUserPreference(text: String) {
        guard let user = user else { return }

        Task {
            do {
                try await UserManager.shared.addUserPreferences(preference: text, userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Failed to add preference: \(error)")
            }
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user = user else { return }
        
        Task {
            do {
                try await UserManager.shared.removeUserPreferences(preference: text, userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Failed to remove preference: \(error)")
            }
        }
    }
    
    func addUserMovie() {
        guard let user = user else { return }
        let movie = Movie(id: "1", title: "Avatar 2", isPopular: true)
        
        Task {
            do {
                try await UserManager.shared.addUserMovie(movie: movie, userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Failed to add movie: \(error)")
            }
        }
    }
    
    func removeUserMovie() {
        guard let user = user else { return }
        
        Task {
            do {
                try await UserManager.shared.removeUserMovie(userId: user.userId)
                self.user = try await UserManager.shared.getUser(userId: user.userId)
            } catch {
                print("Failed to remove movie: \(error)")
            }
        }
    }

    
    func saveImage(item: PhotosPickerItem) {
        guard let user = user else { return }
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    print("Failed to load image data")
                    return
                }
                let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
                print("Successfully added!!!")
                print("Path is: \(path)")
                print("Name is: \(name)")
                let userProfileImageUrl = try await StorageManager.shared.getImageUrl(userProfileImagePath: path)
                print("User Profie image url: \(userProfileImageUrl)")
                try await UserManager.shared.updateUserProfileMediaPath(userId: user.userId, path: path, url: userProfileImageUrl.absoluteString)
            } catch let error as NSError {
                print("Error loading image data: \(error.localizedDescription)")
                print("Underlying error: \(error.userInfo[NSUnderlyingErrorKey] ?? "None")")
            }
        }
    }
    
}
