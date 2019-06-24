//
//  ViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var annotations = [MKPointAnnotation]()
    var coordinatesToDisplay: [StudentLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    func fetchData() {
        
        APIRequest.getStudentsLocation(completionHandler: { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            StudentsLocationData.studentsData = data
            self.passDataToMap()
        })
    }
    
    func passDataToMap() {
        
        for val in StudentsLocationData.studentsData {
            let latitude = CLLocationDegrees(val.latitude)
            let longitute = CLLocationDegrees(val.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
            
            let first = val.firstName
            let last = val.lastName
            let mediaURL = val.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
    }
    
    
    func handleGetStudentsLocationData(data: [StudentLocation]?, error: Error?) {
        guard let data = data else{
            print(error?.localizedDescription ?? "error: nil")
            return
        }
        StudentsLocationData.studentsData = data
    }
    
     func getUsersFromVisibleArea(_ coordinates: CLLocation) {
        let students = StudentsLocationData.studentsData
        
        let range = coordinates.coordinate.latitude ... coordinates.coordinate.longitude
//        let studentsCoordinates =
//
        print(coordinates.coordinate)
        
//        for x in studentsCoordinates {
//            print("longitude: \(x.longitude) latitude: \(x.latitude)")
//        }
//
//        coordinatesToDisplay = studentsCoordinates
//        print("new array: \(studentsCoordinates.count) old array: \(students.count)")
    }
    
}

extension MapViewController: MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        
        var visibleArea = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        getUsersFromVisibleArea(visibleArea)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let coordinatesToDisplay = coordinatesToDisplay else {
            return 1
        }
        return coordinatesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = coordinatesToDisplay?[indexPath.row].firstName ?? "no coordinates"
        
        return cell
    }
    
}
