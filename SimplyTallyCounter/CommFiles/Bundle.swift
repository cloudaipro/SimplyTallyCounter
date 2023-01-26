//
//  Bundle.swift
//  SimplyScanner
//
//  Created by alex on 2022-06-02.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return "\(infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")"
    }
    var buildVersionNumber: String {
        return "\(infoDictionary?["CFBundleVersion"] as? String ?? "1")"
    }
}
