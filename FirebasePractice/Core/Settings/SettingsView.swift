//
//  SettingsView.swift
//  FirebasePractice
//
//  Created by Sabr on 27.07.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var vm = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try vm.logOut()
                        showSignInView = true
                    } catch {
                        print("Error. \(error)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await vm.delete()
                        showSignInView = true
                    } catch {
                        print("Error. \(error)")
                    }
                }            } label: {
                Text("Delete account")
            }
            if vm.providersAuthUser.contains(.email) {
                emailSection
            }
            if vm.authUser?.isAnonymous == true {
                anonymousSection
            }
        }
        .onAppear {
            vm.loadProviders()
            vm.loadUser()
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(true))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await vm.reset()
                        print("Password RESET!!!")
                    } catch {
                        print("Error. \(error)")
                    }
                }
            }
        } header: {
            Text("Email functions")

        }

    }
    
    private var anonymousSection: some View {
        Section {
            Button("Link with Google") {
                Task {
                    do {
                        try await vm.linkGoogleAccount()
                        print("Google linked!!!")
                    } catch {
                        print("Error. \(error)")
                    }
                }
            }
            Button("Link with Apple") {
                Task {
                    do {
                        try await vm.linkAppleAccount()
                        print("Apple linked!!!")
                    } catch {
                        print("Error. \(error)")
                    }
                }
            }
            Button("Link with Email") {
                Task {
                    do {
                        try await vm.linkEmailAccount()
                        print("Email linked!!!")
                    } catch {
                        print("Error. \(error)")
                    }
                }
            }
        } header: {
            Text("Sign In")
        }

    }
}
