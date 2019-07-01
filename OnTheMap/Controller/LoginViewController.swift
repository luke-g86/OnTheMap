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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: When login button is tapped, username and password are being used for calling Udacity API
    
    @IBAction func loginTapped(_ sender: Any) {
        loginTextField.endEditing(true)
        loginTextField.isEnabled = false
        passwordTextField.endEditing(true)
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    
    
        
        if (loginTextField.text != nil && passwordTextField.text != nil) {
            APIRequests.login(username: loginTextField.text!, password: passwordTextField.text!, completionHandler: loginHandleResponse(success:error:))
        }
        else {
            alert("Login", "Please provide username and password")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.isEnabled = true
        loginTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        activityIndicator.isHidden = true
        
        loginTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginTextField.text = ""
        passwordTextField.text = ""
        
        subscribeToKeyboardNotifications()
        
        
    }
    
    override func viewDidLoad() {
        loginButton.isEnabled = true
        activityIndicator.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    //MARK: If login is successful, then application calls for logged user personal Data (in this case random data generated at Udacity's end)
    
    func loginHandleResponse(success: Bool, error: Error?) {
        
        if success {
            print("ok")
            loginButton.isEnabled = true
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
            APIRequests.getUserData(completionHandler: userDataResponseHandler(response:error:))
        } else {
            print(error?.localizedDescription ?? "")
            alert("Login failed", "You have provided wrong user name or password. Please try again")
            
            loginButton.isEnabled = true
            passwordTextField.isEnabled = true
            loginTextField.isEnabled = true
            activityIndicator.isHidden = true
        }
    }
    
    
    func alert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: User data from API are being saved in StorageController which is a part of a MODEL
    
    func userDataResponseHandler(response: UserData?, error: Error?) {
        guard let response = response else {
            print(error?.localizedDescription ?? "")
            return
        }
        StorageController.user = PostLocation(uniqueKey: response.key, firstName: response.firstName, lastName: response.lastName, mapString: nil, mediaURL: nil, latitude: nil, longitude: nil)
        
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else {
            alert("Login", "Please provide username and password")
            return
        }
    }
    
    //MARK: showing up the keyboard will scroll the view
    
    // Keyboard appears
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: -keyboardSize.height + window.height)
            
        }
    }
    
    // Keyboard disappears
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        let viewHeight = UIScreen.main.bounds.height
        
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: self.view.frame.origin.y,
                                 width: self.view.frame.width,
                                 height: viewHeight)
        
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForResizing(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
