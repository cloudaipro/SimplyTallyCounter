//
//  IntroView.swift
//  SimplyTallyCounter
//
//  Created by Alex on 2023-01-26.
//

import UIKit
import RxSwift
import RxGesture

class IntroView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func didMoveToSuperview() {
        rx.tapGesture().asDriver().drive() { tap in
            if tap.state == .ended {
                self.removeFromSuperview()
            }
        }.disposed(by: rx.disposeBag)
    }

}
