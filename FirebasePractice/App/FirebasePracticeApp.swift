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
            AnalyticsView()
//            PerformanceView()
//            CrashView()
//             RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
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
