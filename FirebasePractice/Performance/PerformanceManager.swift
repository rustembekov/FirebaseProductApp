//
//  PerformanceManager.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 14.09.2024.
//

import Foundation
import FirebasePerformance

final class PerformanceManager {
    
    static let shared = PerformanceManager()
    private init() { }
    
    private var traces: [String:Trace] = [:]
    
    func startTrace(name: String) {
        let trace = Performance.startTrace(name: name)
        traces[name] = trace
    }
    
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    
    func stopTrace(name: String) {
        guard let trace = traces[name] else { return }
        trace.stop()
        traces.removeValue(forKey: name)
    }
}
