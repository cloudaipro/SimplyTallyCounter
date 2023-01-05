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
    var counter: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        volumeHandler = JPSVolumeButtonHandler(up: {
            self.doDown()
        }, downBlock: {
            self.doDown()
            
        })
        volumeHandler?.start(true)
        
        tapView.rx.tapGesture().asDriver().drive { tap in
            if tap.state == .ended {
                self.doUP()
            }
        }.disposed(by: rx.disposeBag)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        volumeHandler?.start(false)
        super.viewDidDisappear(animated)
    }
    private func doUP() {
        Vibration.light.vibrate()
        self.counter += 1
        self.updateLabel()
    }
    private func doDown() {
        if self.counter > 0 {
            Vibration.error.vibrate()
            self.counter -= 1
            self.updateLabel()
        }
    }
    private func updateLabel() {
        UIView.transition(with: txtCounter,
                      duration: 0.25,
                       options: .transitionCurlUp,
                    animations: { self.txtCounter.text = "\(self.counter)" }, completion: nil)
    }
}

