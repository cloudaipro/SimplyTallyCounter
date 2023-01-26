//
//  BannerAd.swift
//  SimplyScanner
//
//  Created by Alex on 2022-12-14.
//

import UIKit
import GoogleMobileAds
import AdSupport
import RxSwift

class BannerAd : MyAdUnit {
    let adBannerView: GADBannerView
    let adViewSubject: BehaviorSubject<GADBannerView?> = BehaviorSubject<GADBannerView?>(value: nil)
    let adViewContainer: UIView?

    init(rootViewController: UIViewController, adType: AdType, forKey: String, width: CGFloat, adViewContainer: UIView? = nil) {
        self.adBannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(width)) //320))
        self.adViewContainer = adViewContainer
        super.init(adType: adType)

        self.adBannerView.adUnitID = (MyAdUnit.TestMode) ? MyAdUnit.AdTestUnitID[adType.rawValue] : MyAdUnit.AdUnitID[forKey]
        self.adBannerView.delegate = self
        self.adBannerView.rootViewController = rootViewController
        let request = GADRequest()
        let extras = GADExtras()
        extras.additionalParameters = ["npa": "1"]
        request.register(extras)
        self.adBannerView.load(request)
    }

}

extension BannerAd: GADBannerViewDelegate
{
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error){
        SpeedLog.print("bannerView error: \(error.localizedDescription)")
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        if let adViewContainer = adViewContainer {
            adViewContainer.subviews.forEach { $0.removeFromSuperview() }
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            
            let translateTransform = CGAffineTransform(translationX: 0, y: bannerView.bounds.size.height)
            bannerView.transform = translateTransform
            adViewContainer.addSubviewEqualSize(bannerView)
            UIView.animate(withDuration: 0.5) {
                bannerView.transform = CGAffineTransform.identity
            }
        }
        adViewSubject.onNext(bannerView)
    }
}
