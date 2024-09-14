//
//  AnalyticsManager.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 14.09.2024.
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init (){}
    
    func logEvent(name: String, params : [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
}
