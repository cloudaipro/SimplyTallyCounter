//
//  InterstitialAd.swift
//  SimplyScanner
//
//  Created by Alex on 2022-12-14.
//

import UIKit
import GoogleMobileAds
import AdSupport
import RxSwift

class InterstitialAd : MyAdUnit {
    var adInterstitial: GADInterstitialAd?
    let adInterstitialSubject: BehaviorSubject<GADInterstitialAd?> = BehaviorSubject<GADInterstitialAd?>(value: nil)
    let adUnitID: String
    init(adType: AdType, forKey: String) {
        self.adUnitID = ((MyAdUnit.TestMode) ? MyAdUnit.AdTestUnitID[adType.rawValue] : MyAdUnit.AdUnitID[forKey])!
        super.init(adType: adType)
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.adInterstitial = ad
            self.adInterstitial?.fullScreenContentDelegate = self
            self.adInterstitialSubject.onNext(ad)
        })
    }
}

extension InterstitialAd: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
}

