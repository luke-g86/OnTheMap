//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit



class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationSearchField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var seachOnMapButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var user = LoginViewController()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let first = user.user.firstName.first?.uppercased() else {
            return
        }
         let userName = "\(first)"+"\(user.user.firstName.lowercased().dropFirst())"
        
        locationSearchField.delegate = self
        okButton.isEnabled = false
        textLabel.text = "\(userName), type location name or select it on a map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        okButton.isHidden = true
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        self.performSegue(withIdentifier: "addressToMap", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addressToMap" {
            if let navigationVC = segue.destination as? UINavigationController, let targetVC = navigationVC.topViewController as? AddLocationOnMapViewController {
                targetVC.addressProvidedbyTheUser = locationSearchField.text
                targetVC.nameToMap = true
            }
        }
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        okButton.isEnabled = false
    
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .transitionFlipFromTop,
                       animations: {
                        self.okButton.isHidden = false
        }, completion: nil)
        
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        if text.count > 5 {
            okButton.isEnabled = true
        }
 
    }
}


