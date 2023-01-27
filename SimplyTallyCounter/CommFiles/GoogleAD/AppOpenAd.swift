//
//  AppOpenAd.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-26.
//

import UIKit
import GoogleMobileAds
import AdSupport
import RxSwift

class AppOpenAd: MyAdUnit, GADFullScreenContentDelegate {
    let adUnitID: String
    var adOpenApp: GADAppOpenAd? = nil
    var loadTime = Date()
    
    init() {
        self.adUnitID = MyAdUnit.TestMode ? MyAdUnit.AdTestUnitID[AdType.app_open.rawValue]! : MyAdUnit.AdUnitID[AdType.app_open.rawValue]!
        super.init(adType: AdType.app_open)
    }
    init(forKey: String) {
        self.adUnitID = MyAdUnit.TestMode ? MyAdUnit.AdTestUnitID[AdType.app_open.rawValue]! : MyAdUnit.AdUnitID[forKey]!
        super.init(adType: AdType.app_open)
    }
    func requestAppOpenAd() {
        adOpenApp = nil
        GADAppOpenAd.load(withAdUnitID: (MyAdUnit.TestMode ? MyAdUnit.AdTestUnitID[AdType.app_open.rawValue] : MyAdUnit.AdUnitID[AdType.app_open.rawValue])!, request: GADRequest(), orientation: .portrait) { appOpenAd, error in
            if let error = error {
                SpeedLog.print(error.localizedDescription)
            }
            else {
                self.adOpenApp = appOpenAd
                self.adOpenApp?.fullScreenContentDelegate = self
                self.loadTime = Date()
            }
        }
    }
    func tryToPresentAd() {
        if let ad = adOpenApp, let rootController = UIWindow.key?.rootViewController, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            ad.present(fromRootViewController: rootController)
        }
        else {
            requestAppOpenAd()
        }
    }
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        requestAppOpenAd()
    }
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
    }
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
}
