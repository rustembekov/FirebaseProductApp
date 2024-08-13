//
//  ViewController.swift
//  FirebasePractice
//
//  Created by Sabr on 30.07.2024.
//

import Foundation
import UIKit

final class ViewController {
    
    static let shared = ViewController()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? ViewController.getKeyWindow()?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    private static func getKeyWindow() -> UIWindow? {
        let activeScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        return activeScenes.first?.windows.first { $0.isKeyWindow }
    }
}

