//
//  RatingAppManager.swift
//  SimplyScanner
//
//  Created by Alex on 2022-12-16.
//

import UIKit
import StoreKit
import Defaults
import MessageUI
import DeviceKit

public struct RatingRequesterConfiguration {
    public typealias RatingRequestedHandler = ((String) -> Void)

    /// The minimum amounts of days until the first prompt should be shown.
    let daysUntilPrompt: Int

    /// The number of app sessions required until the first prompt should be shown.
    let sessionsUntilPrompt: Int

    /// The number of events required until the first prompt should be shown.
    let eventsUntilPrompt: Int

    /// Will be called after the user is requested for a review.
    let onRatingRequest: RatingRequestedHandler?

    public init(daysUntilPrompt: Int, sessionsUntilPrompt: Int, eventsUntilPrompt: Int, onRatingRequest: RatingRequesterConfiguration.RatingRequestedHandler?) {
        self.daysUntilPrompt = daysUntilPrompt
        self.sessionsUntilPrompt = sessionsUntilPrompt
        self.eventsUntilPrompt = eventsUntilPrompt
        self.onRatingRequest = onRatingRequest
    }
}

class RatingAppManager: NSObject {
    public static let shared: RatingAppManager = RatingAppManager()
//#if DEBUG
//    let isDebuggingEnabled = true
//#else
    let isDebuggingEnabled = false
//#endif
    let configuration = RatingRequesterConfiguration(daysUntilPrompt: 7, sessionsUntilPrompt: 5, eventsUntilPrompt: 3, onRatingRequest: nil)
    
    var shouldAskForRating: Bool {
        guard !isDebuggingEnabled else { return true }
        guard let firstLaunchDate = Defaults[.firstOpenDate] else { return false }
        let timeSinceFirstLaunch = Date().timeIntervalSince(firstLaunchDate)
        let timeUntilRate: TimeInterval = 60 * 60 * 24 * TimeInterval(configuration.daysUntilPrompt)
        
        if  Defaults[.appSessionsCount] < configuration.sessionsUntilPrompt ||
            Defaults[.ratingEventsCount] < configuration.eventsUntilPrompt ||
            timeSinceFirstLaunch < timeUntilRate ||
            Defaults[.lastVersionPromptedForReview] == Bundle.main.releaseVersionNumber ||
            Defaults[.reviewManually] {
            return false
        }
        if Defaults[.ratingEventsCount] % Int32(configuration.eventsUntilPrompt) > 0 {
            return false
        }
        
        return true
        /*
        return Defaults[.appSessionsCount] >= configuration.sessionsUntilPrompt
        && Defaults[.ratingEventsCount] >= configuration.eventsUntilPrompt
        && timeSinceFirstLaunch >= timeUntilRate
        && Defaults[.lastVersionPromptedForReview] != Bundle.main.releaseVersionNumber //applicationVersionProvider()
         */
    }
    
    func askForRatingIfNeeded() {
        //guard shouldAskForRating else { return }
        
        let requestWorkItem = DispatchWorkItem {
            self.askForRating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: requestWorkItem)
    }
    
    func askForRating() {
        Defaults[.lastVersionPromptedForReview] = Bundle.main.releaseVersionNumber //applicationVersionProvider()
        
#if os(macOS)
        SKStoreReviewController.requestReview()
#else
        guard let scene = UIApplication.shared.activeScene else { return }
        SKStoreReviewController.requestReview(in: scene)
#endif
    }
    
    static func didPerformSignificantEvent() {
        Defaults[.ratingEventsCount] += 1
    }
    
    @objc static public func applicationDidBecomeActive() { //_ notification: Notification) {
        Defaults[.appSessionsCount] += 1
        
        if Defaults[.firstOpenDate] == nil {
            Defaults[.firstOpenDate] = Date()
        }
    }
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "APP_ID") as? String else { return } // 1619943223
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")
        else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:]) { success in
            if success {
                Defaults[.lastVersionPromptedForReview] = Bundle.main.releaseVersionNumber //applicationVersionProvider()
                Defaults[.reviewManually] = true
            }
        }
    }
    
    func feedback(parent: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            let body: String = NSLocale.current.languageCode == "zh" ? """
            
            
            Simply Tally Counter 版本:\(Bundle.main.releaseVersionNumber)(\(Bundle.main.buildVersionNumber))
            iPhone 型號:\(Device.current), \(UIDevice.current.systemVersion)
            區域: \(NSLocale.current.regionCode ?? ""), 語言:\(NSLocale.current.languageCode ?? "")
            為了更好的協助，我們會將以上信息提供給我們的開發者，請勿刪除。
            """
            : """
            
            
            Simply Tally Counter version:\(Bundle.main.releaseVersionNumber)(\(Bundle.main.buildVersionNumber))
            iPhone info:\(Device.current), \(UIDevice.current.systemVersion)
            region: \(NSLocale.current.regionCode ?? ""), language:\(NSLocale.current.languageCode ?? "")
            For better assistance, we will provide the above information to our developers, please do not delete.
            """
            
            mail.mailComposeDelegate = self
            mail.setSubject("Simply Tally Counter Feedback")
            mail.setToRecipients(["imskchen@gmail.com"])
            mail.setMessageBody(body, isHTML: false)
            
            parent.present(mail, animated: true)
        } else {
            let mailURL = URL(string: "message://")!
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

extension RatingAppManager: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}

extension Defaults.Keys {
    static let firstOpenDate = Key<Date?>("firstOpenDate", default: nil)
    static let appSessionsCount = Key<Int32>("appSessionsCount", default: 0)
    static let ratingEventsCount = Key<Int32>("ratingEventsCount", default: 0)
    static let lastVersionPromptedForReview = Key<String>("lastVersionPromptedForReview", default: "1.0")
    static let reviewManually = Key<Bool>("reviewManually", default: false)
}
