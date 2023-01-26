//
//  RoundButton.swift
//  HHMobile
//
//  Created by Shih-Kung Chen on 2019-06-04.
//  Copyright © 2019 CCS. All rights reserved.
//

// This is a custom button class where the left and right side of the button
// is a halve circle.

import Foundation
import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }
    func setupButton() {
        layer.cornerRadius  = frame.size.height/2
        layer.masksToBounds = true
        self.tintColor = nil
    }
}

