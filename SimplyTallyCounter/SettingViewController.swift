//
//  SettingViewController.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-25.
//

import UIKit
import RxGesture
import RxSwift

class SettingViewController: UIViewController {
    
    @IBOutlet var resetView: UIView!
    @IBOutlet var rateView: UIView!
    @IBOutlet var shareView: UIView!
    @IBOutlet var feedbackView: UIView!
    @IBOutlet var verLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        verLabel.text = "v\(Bundle.main.releaseVersionNumber) build \(Bundle.main.buildVersionNumber)"

        // Do any additional setup after loading the view.
        resetView.rx.tapGesture().asDriver().drive() { tap in
            if tap.state == .ended, let vc = (self.presentingViewController as? ViewController) {
                let alert = UIAlertController(title: "Reset counter", message: "Are you sure to reset the counter?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.dismiss(animated: true) {
                        if vc.counter > 0 {
                            vc.counter = 0
                            vc.updateLabel(bUp: false, animated: false)
                        }
                        let introView = Bundle.main.loadNibNamed("IntroView", owner: self)?.first as! UIView
                        vc.tapView.addSubviewEqualSize(introView)
                    }}))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }.disposed(by: rx.disposeBag)
        rateView.rx.tapGesture().asDriver().drive() { tap in
            if tap.state == .ended {
                self.dismiss(animated: true) {
                    RatingAppManager.shared.askForRating()
                }
            }
        }.disposed(by: rx.disposeBag)
        shareView.rx.tapGesture().asDriver().drive() { tap in
            if tap.state == .ended, let vc = (self.presentingViewController as? ViewController) {
                self.dismiss(animated: true) {
                    guard let appID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String else { return } // 1619943223
                    let items = ["One of the most powerful and easy-to-use apps I've been used! Here is the link to get the app from App Store.", URL(string: "https://apps.apple.com/app/simply-tally-counter/id\(appID)")!] as [Any]
                    let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    avc.setValue("I warmly recommend an excellent app to you", forKey: "subject")
                    avc.completionWithItemsHandler =  { type, ok, items, err in
                        if ok {
                            avc.completionWithItemsHandler = nil
                        }
                    }
                    //Apps to exclude sharing to
                    avc.excludedActivityTypes = [
                        UIActivity.ActivityType.saveToCameraRoll,
                        UIActivity.ActivityType.print,
                        UIActivity.ActivityType.addToReadingList,
                        UIActivity.ActivityType.assignToContact,
                        UIActivity.ActivityType.markupAsPDF,
                        UIActivity.ActivityType.copyToPasteboard,
                        UIActivity.ActivityType.openInIBooks,
                        UIActivity.ActivityType.postToVimeo,
                        UIActivity.ActivityType.postToFlickr,
                        UIActivity.ActivityType.postToWeibo,
                        UIActivity.ActivityType.postToTencentWeibo ]
                    
                    DispatchQueue.main.async {
                        //Present the sendView on iPhone
                        // If user on iPad
                        vc.present(avc, animated: true, completion: nil)
                    }
                    
                }
            }
        }.disposed(by: rx.disposeBag)
        feedbackView.rx.tapGesture().asDriver().drive() { tap in
            if tap.state == .ended, let vc = (self.presentingViewController as? ViewController) {
                self.dismiss(animated: true) {
                    RatingAppManager.shared.feedback(parent: vc)
                }
            }
        }.disposed(by: rx.disposeBag)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
