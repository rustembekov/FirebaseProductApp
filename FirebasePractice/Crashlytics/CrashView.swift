//
//  CrashView.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 07.09.2024.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Press a button to simulate a crash:")
                .font(.headline)
            
            Button("Press First Button") {
                fatalError("Crash was triggered") 
            }
            .foregroundColor(.red)
            
            Button("Press Second Button") {
                let myString: String? = nil
                let string = myString!
            }
            .foregroundColor(.orange)
            
            Button("Press Third Button") {
                let options: [String] = []
                _ = options[0]
            }
            .foregroundColor(.yellow)
        }
        .padding()
        .onAppear {
            CrashManager.shared.setUserId(userId: "AAAAA")
        }
    }
}

#Preview {
    CrashView()
}

