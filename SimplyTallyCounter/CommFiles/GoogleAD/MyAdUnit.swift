//
//  AdManager.swift
//  SimplyScanner
//
//  Created by Alex on 2022-12-14.
//

import UIKit
import GoogleMobileAds
import AdSupport
import RxSwift

enum AdType : String {
    case app_open = "App Open"
    case banner = "Banner"
    case interstitial = "Interstitial"
    case interstitial_video = "Interstitial Video"
    case rewarded = "Rewarded"
    case rewarded_interstitial = "Rewarded Interstitial"
    case native_advanced = "Native Advanced"
    case native_advanced_video = "Native Advanced Video"
}

class MyAdUnit : NSObject {
    static var TestMode: Bool = false
    let adType: AdType
    
    init(adType: AdType) {
        self.adType = adType
    }
}
