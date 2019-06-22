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
    

    override func viewWillAppear(_ animated: Bool) {
        print("data in StudentsDataArray \(StudentsLocationData.studentsData.count)")

    }
}


extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocationData.studentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = ("\(StudentsLocationData.studentsData[indexPath.row].firstName) \(StudentsLocationData.studentsData[indexPath.row].lastName)")
        
        return cell
    }
    
    
}
