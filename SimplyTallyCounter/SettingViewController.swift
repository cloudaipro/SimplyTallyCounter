//
//  SettingViewController.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-25.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var rateView: UIView!
    @IBOutlet var shareView: UIView!
    @IBOutlet var feedbackView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
