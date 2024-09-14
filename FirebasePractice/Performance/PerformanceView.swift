//
//  PerformanceView.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 10.09.2024.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    
    @State private var title: String = "Some Title"

    var body: some View {
        Text("Hello, World!")
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                
                PerformanceManager.shared.startTrace(name: "performance_screen_time")
            }
            .onDisappear {
                PerformanceManager.shared.stopTrace(name: "performance_screen_time")
            }
    }
    
    private func configure() {
        PerformanceManager.shared.startTrace(name: "performance_view_loading")

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "performance_view_loading", value: "Started downloading", forAttribute: "func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "performance_view_loading", value: "Finished downloading", forAttribute: "func_state")

            PerformanceManager.shared.stopTrace(name: "performance_view_loading")
        }
        
    }
    
    func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let metric = HTTPMetric(url: url, httpMethod: .get) else { return }
        metric.start()

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
                print("SUCCESS")
            } catch {
                print(error)
                metric.stop()
            }
        }
    }

}
#Preview {
    PerformanceView()
}
