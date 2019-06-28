//
//  ResultViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 28/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var success = false
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        status(_success: success)
    }
    
    func status(_success: Bool) {
        if success {
            label.text = "Yay, success!"
            Flag.dataSubmitted = true
        } else {
            label.text = "Oops... something went wrong"
            Flag.dataSubmitted = false
        }
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
        self.show(vc, sender: nil)
    }
    
}




