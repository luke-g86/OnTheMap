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
    
    var array = [StudentLocation]()

    
    override func viewWillAppear(_ animated: Bool) {
        
        print("data in StudentsDataArray \(StudentsLocationData.studentsData.count)")
        self.title = "Students list"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
        // Sorting students location array
        array.append(contentsOf: StudentsLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
        }
    }
    



extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = ("\(array[indexPath.row].firstName) \(array[indexPath.row].lastName)")
        
        return cell
    }
    
    
}
