//
//  ProfileViewModel.swift
//  FirebasePractice
//
//  Created by Sabr on 02.08.2024.
//

import Foundation

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
        
        Task {
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

}
