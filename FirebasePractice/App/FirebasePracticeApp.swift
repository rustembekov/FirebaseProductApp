//
//  FirebasePracticeApp.swift
//  FirebasePractice
//
//  Created by Sabr on 26.07.2024.
//

import SwiftUI
import Firebase

@main
struct FirebasePracticeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CrashView()
            // RootView() // Uncomment if you have a main root view.
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Enable Crashlytics data collection
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // This can be used for additional configurations if needed.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // This can be used for additional configurations if needed.
    }
}
