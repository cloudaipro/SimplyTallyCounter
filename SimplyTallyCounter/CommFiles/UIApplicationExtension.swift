//
//  UIApplicationExtension.swift
//  SimplyScanner
//
//  Created by Alex on 2022-12-16.
//

import UIKit

extension UIApplication {
    var activeScene: UIWindowScene? {
        connectedScenes.first{ $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
