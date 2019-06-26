//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class ButtonsDesign: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        tintColor = UIColor.white
        backgroundColor = UIColor(red:0.11, green:0.41, blue:0.99, alpha:1.0)
        layer.shadowColor = UIColor.darkGray.cgColor
        superview?.bringSubviewToFront(self)
        layer.frame.size.width = 50

    }
    
   func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
