//
//  AnalyticsView.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 14.09.2024.
//

import Foundation
import FirebaseAnalytics
import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        VStack {
            Button("Click first button") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_FirstClick")
            }
            
            Button("Click second button") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_SecondClick")
            }
            
        }
    }
}

#Preview {
    AnalyticsView()
}
