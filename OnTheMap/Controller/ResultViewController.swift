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
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var success = false
    
    override func viewDidLoad() {
        status(success)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func status(_ success: Bool) {
        if success {
            imageView.image = UIImage(named: "success")
            label.text = "Yay, success!"
            Flag.dataSubmitted = true
        } else {
            label.text = "Oops... something went wrong. Check your internet connection and try again"
            imageView.image = UIImage(named: "fail")
            Flag.dataSubmitted = false
        }
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
        
    
        // MARK: Updating and moving to the MapViewController
        // fetchData downloads new array of users' locations from API

        vc.tabBarController?.tabBar.isHidden = false
        self.show(vc, sender: nil)
    }
    
}




