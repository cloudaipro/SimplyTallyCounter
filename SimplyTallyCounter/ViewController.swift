//
//  ViewController.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-04.
//

import UIKit
//import JPSVolumeButtonHandler
//import RxSwift
import RxGesture
import NSObject_Rx
import AudioToolbox
import GoogleMobileAds
import AdSupport
import UserMessagingPlatform

enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        @available(iOS 13.0, *)
        case soft
        @available(iOS 13.0, *)
        case rigid
        case selection
        case oldSchool

        public func vibrate() {
            switch self {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .light:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case .medium:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case .heavy:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case .soft:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            case .selection:
                UISelectionFeedbackGenerator().selectionChanged()
            case .oldSchool:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }

class ViewController: UIViewController {
//    var volumeHandler: JPSVolumeButtonHandler? = nil
    @IBOutlet var txtCounter: UILabel!
    @IBOutlet var tapView: UIView!
    @IBOutlet var adView: UIView!
    @IBOutlet var minusView: UIView!
    var adBanner: MyAdUnit?
    var counter: Int = 0
    
    private func UMPProcess() {
         // Create a UMPRequestParameters object.
         let parameters = UMPRequestParameters()
         // Set tag for under age of consent. false means users are not under age
         // of consent.
         
         // for debugging
//         UMPConsentInformation.sharedInstance.reset()
//         let debugSettings = UMPDebugSettings()
//         debugSettings.testDeviceIdentifiers = ["FE3939C3-28F2-4666-AFAD-CF789F182AEA"]
//         debugSettings.geography = .EEA
//         parameters.debugSettings = debugSettings
         
         parameters.tagForUnderAgeOfConsent = false
         
           // Request an update for the consent information.
           UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
             [weak self] requestConsentError in
             guard let self else { return }

             if let consentError = requestConsentError {
               // Consent gathering failed.
               return print("Error: \(consentError.localizedDescription)")
             }

             UMPConsentForm.loadAndPresentIfRequired(from: self) {
                 [weak self] loadAndPresentError in
                 guard let self else { return }

                 if let consentError = loadAndPresentError {
                     // Consent gathering failed.
                     return print("Error: \(consentError.localizedDescription)")
                     
                 }
                 // Consent has been gathered.
                 if UMPConsentInformation.sharedInstance.canRequestAds {
                     _ = self.startGoogleMobileAdsSDK
                 }
             }
           }
         
         // Check if you can initialize the Google Mobile Ads SDK in parallel
         // while checking for new consent information. Consent obtained in
         // the previous session can be used to request ads.
         if UMPConsentInformation.sharedInstance.canRequestAds {
             _ = self.startGoogleMobileAdsSDK
             
         }
     }
    // The lazy property is used instead of unavailable `dispatch_once` to
    // initialize the Google Mobile Ads SDK only once.
    private lazy var startGoogleMobileAdsSDK: Void = {
        AppDelegate.bLoadedGADMobileAds.filter{ $0 }
            .subscribe { _ in
                self.adBanner = BannerAd(rootViewController: self, adType: .banner, forKey: "Banner", width: 320, adViewContainer: self.adView)
            }
            .disposed(by: rx.disposeBag)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tapView.rx.tapGesture().asDriver().drive { tap in
            if tap.state == .ended {
                self.doUP()
            }
        }.disposed(by: rx.disposeBag)
        minusView.rx.tapGesture().asDriver().drive { tap in
            if tap.state == .ended {
                self.doDown()
            }
        }.disposed(by: rx.disposeBag)

        UMPProcess()

        let introView = Bundle.main.loadNibNamed("IntroView", owner: self)?.first as! UIView
        tapView.addSubviewEqualSize(introView)
    }   
    override func viewDidDisappear(_ animated: Bool) {
//        volumeHandler?.start(false)
        super.viewDidDisappear(animated)
    }
    private func doUP() {
        Vibration.medium.vibrate()
        self.counter += 1
        self.updateLabel(bUp: true)
    }
    private func doDown() {
        if self.counter > 0 {
            Vibration.error.vibrate()
            self.counter -= 1
            self.updateLabel(bUp: false)
        }
    }
    func updateLabel(bUp: Bool, animated: Bool = true) {
        //self.txtCounter.text = "\(self.counter)"

        UIView.transition(with: txtCounter,
                          duration: animated ? 0.25 : 0,
                          options: bUp ? .transitionCurlUp : .transitionCurlDown,
                    animations: { self.txtCounter.text = "\(self.counter)" }, completion: nil)
    }
    
    @IBAction func doMinmus(_ sender: Any) {
        doDown()
    }
    @IBAction func openSetting(_ sender: Any) {
        let vc = SettingViewController()
        self.present(vc, animated: true)
    }
}
