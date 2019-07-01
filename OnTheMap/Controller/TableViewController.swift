//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 23/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var array = [StudentLocation]()
    @IBOutlet weak var postLocationButton: UIBarButtonItem!
    
    @ IBAction func logoutButtonTapped(sender: Any) {
        APIRequests.logout { (success: Bool, error: Error?) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            print(error?.localizedDescription ?? "")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        print("data in StudentsDataArray \(StudentsLocationData.studentsData.count)")
        self.title = "Students list"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        // Sorting students location array
        array.append(contentsOf: StudentsLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
        }
    
    @IBAction func buttonTapped(sender: Any){
        if Flag.dataSubmitted {
            let dialogWindow = UIAlertController(title: "Location exists", message: "You've already posted your location. Would you like to overwrite it?", preferredStyle: .alert)
            dialogWindow.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.performSegue(withIdentifier: "addLocation", sender: sender)
            }))
            dialogWindow.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
                dialogWindow.dismiss(animated: true, completion: nil)
            }))
            self.present(dialogWindow, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "addLocation", sender: sender)
        }
        
    }
    
    
    }

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        
        cell.textLabel?.text = ("\(array[indexPath.row].firstName) \(array[indexPath.row].lastName)")
        
        if array[indexPath.row].mediaURL.isValidURL {
            cell.accessoryType = .disclosureIndicator
        }
        cell.imageView?.image = UIImage(named: "location-not-active")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        var mediaURL = array[indexPath.row].mediaURL
        
        if mediaURL.isValidURL {
            
            if mediaURL.starts(with: "www") {
                mediaURL = "https://" + mediaURL
            }
            let url = URL(string: mediaURL)
            UIApplication.shared.open(url!)
            
        } else {
            
            let alert = UIAlertController(title: "No URL", message: "There's no URL to open", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
