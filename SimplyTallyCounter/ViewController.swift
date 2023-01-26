//
//  ViewController.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-04.
//

import UIKit
import JPSVolumeButtonHandler
//import RxSwift
import RxGesture
import NSObject_Rx
import AudioToolbox

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
    var volumeHandler: JPSVolumeButtonHandler? = nil
    @IBOutlet var txtCounter: UILabel!
    @IBOutlet var tapView: UIView!
    @IBOutlet var adView: UIView!
    var adBanner: MyAdUnit?
    var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        volumeHandler = JPSVolumeButtonHandler(up: {
            self.doUP()
        }, downBlock: {
            self.doDown()
            
        })
        volumeHandler?.start(true)
        
        tapView.rx.tapGesture().asDriver().drive { tap in
            if tap.state == .ended {
                self.doUP()
            }
        }.disposed(by: rx.disposeBag)
        
        AppDelegate.bLoadedGADMobileAds.filter{ $0 }
            .subscribe { _ in
                self.adBanner = BannerAd(rootViewController: self, adType: .banner, forKey: "Banner", width: 320, adViewContainer: self.adView)
            }
            .disposed(by: rx.disposeBag)

    }   
    override func viewDidDisappear(_ animated: Bool) {
        volumeHandler?.start(false)
        super.viewDidDisappear(animated)
    }
    private func doUP() {
        Vibration.light.vibrate()
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
