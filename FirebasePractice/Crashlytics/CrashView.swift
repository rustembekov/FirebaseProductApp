//
//  CrashView.swift
//  FirebasePractice
//
//  Created by Sabyrzhan Rustembekov on 07.09.2024.
//

import SwiftUI

struct CrashView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            Button("Press First Button") {
                fatalError("Crash was triggered")
            }
            
            Button("Press Second Button") {
                let myString: String? = nil
                
            }
            
            Button("Press Third Button") {
                
            }
        }
        
    }
}

#Preview {
    CrashView()
}
