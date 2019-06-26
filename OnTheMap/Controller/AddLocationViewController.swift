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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSearchField.delegate = self
        okButton.isEnabled = false
        
        
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
        resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        okButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        okButton.isEnabled = true
    }
}


