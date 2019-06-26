//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTetField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    

    @IBAction func loginTapped(_ sender: Any) {
        APIRequests.login(username: APIRequests.udacityLogin.udacity.username, password: APIRequests.udacityLogin.udacity.password) { (success, error) in
            if success {
                print("ok")
            } else {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginTextField.delegate = self
        passwordTetField.delegate = self
        
    }
    
    override func viewDidLoad() {
        
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
}
