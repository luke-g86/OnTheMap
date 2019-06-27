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
    
    var user = UserData(firstName: "john", lastName: "doe", key: "123")
    
    
    @IBAction func loginTapped(_ sender: Any) {
        APIRequests.login(username: APIRequests.udacityLogin.udacity.username, password: APIRequests.udacityLogin.udacity.password, completionHandler: loginHandleResponse(success:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginTextField.delegate = self
        passwordTetField.delegate = self
        
    }
    
    func loginHandleResponse(success: Bool, error: Error?) {
        if success {
            print("ok")
            APIRequests.getUserData(completionHandler: userDataResponseHandler(response:error:))
        } else {
            print(error?.localizedDescription ?? "")
        }
    }
    
    
    func userDataResponseHandler(response: UserData?, error: Error?) {
        guard let response = response else {
           print(error?.localizedDescription ?? "")
            return
        }
        user = UserData(firstName: response.firstName, lastName: response.lastName, key: response.key)
        print("user data: \(user)")
        
    }
}



extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
}
