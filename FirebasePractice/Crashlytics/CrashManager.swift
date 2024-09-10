//
//  CrashManager.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 10.09.2024.
//

import Foundation
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

class CrashManager {
    static let shared = CrashManager()
    private init() {}
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
}
