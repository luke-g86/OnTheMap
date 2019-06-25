//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        tintColor = UIColor.white
        backgroundColor = UIColor(red:0.11, green:0.41, blue:0.99, alpha:1.0)
        layer.shadowColor = UIColor.darkGray.cgColor
        superview?.bringSubviewToFront(self)
        
        
        
    }
}
