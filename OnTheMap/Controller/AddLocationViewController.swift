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
    @IBOutlet weak var chooseOnMapButton: UIButton!
    @IBOutlet weak var searchAddressButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        var userName: String {
            
            let firstChar = StorageController.user.firstName.first!.uppercased()
            let lastCharacters = StorageController.user.firstName.dropFirst().lowercased()
            
            return firstChar+lastCharacters
        }
        
        locationSearchField.delegate = self
        chooseOnMapButton.isEnabled = false
        textLabel.text = "\(userName), type location name or select it on a map"
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chooseOnMapButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Customer types address to be found and displayed
    
    @IBAction func searchAddressButtonTapped(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationOnTheMap") as! AddLocationOnMapViewController
        vc.navigationItem.title = "Your searched location"
        vc.addressProvidedbyTheUser = locationSearchField.text
        vc.nameToMap = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Customer wants to select location on a map by himself
    
    @IBAction func chooseOnMapButtonTapped(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationOnTheMap") as! AddLocationOnMapViewController
        vc.navigationItem.title = "Choose location on a map"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chooseOnMapButton.isEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .transitionFlipFromTop,
                       animations: {
                        self.chooseOnMapButton.isHidden = false
        }, completion: nil)
        
    }
    
    //MARK: If textfield has more then 5 characters button 'search on map' becomes active
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.count > 5 {
            chooseOnMapButton.isEnabled = true
        }
        
    }
}


