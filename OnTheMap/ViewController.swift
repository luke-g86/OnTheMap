//
//  ViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentsData = [StudentLocation]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchData()
        print("======")
        //        udacityReq()
//        print("students data: \(studentsData)")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
//            print(self.studentsData)
//        }
        
    
    }
    func fetchData() {
        
        DispatchQueue.main.async {
            APIRequest.getStudentsLocation(completionHandler: { (data, error) in
                
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.studentsData = data
                print(self.studentsData.filter{$0.firstName == "Linda"})
            })
            
        }
    }
    

    
    func handleGetStudentsLocationData(data: [StudentLocation]?, error: Error?) {
        guard let data = data else{
            print(error?.localizedDescription ?? "error: nil")
            return
        }
        self.studentsData = data
        
    }
    
    func udacityReq() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}

extension ViewController: MKMapViewDelegate {
    
}
