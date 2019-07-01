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
    @IBOutlet weak var postLocationButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotations = [MKPointAnnotation]()
    var firstLocation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        fetchData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Flag.dataSubmitted {
            fetchData()
        }
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: AddLocation button. If location has been posted (flag checked), users get alert
    
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
    
    //MARK: Logout
    
    @IBAction func logoutButtonTapped(sender: Any) {
        
        APIRequests.logout { (success: Bool, error: Error?) in
            if success {
                print("successful logout")
                self.dismiss(animated: true, completion: nil)
            }
            print(error?.localizedDescription ?? "")
        }
    }
    
    //MARK: Fetching the data from API and saving into the array
    
    func fetchData() {
        Flag.isLoggin = true
        activityIndicatorStatus()
        APIRequests.getStudentsLocation(completionHandler: { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            StudentsLocationData.studentsData = data
            self.passDataToMap()
            Flag.isLoggin = false
        })
    }
    
    //MARK: Function which translates the data from fetched data into the MapView
    
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
    
    //MARK: Closure handler for saving students' location data from API
    
    func handleGetStudentsLocationData(data: [StudentLocation]?, error: Error?) {
        guard let data = data else{
            print(error?.localizedDescription ?? "error: nil")
            return
        }
        StudentsLocationData.studentsData = data
    }
    
    //MARK: activity indicator will be used only if network connection is slow
    
    func activityIndicatorStatus() {
        if Flag.dataSubmitted && Flag.isLoggin {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            activityIndicator.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.activityIndicator.transform = .identity }, completion: nil)
            
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //MARK: Displaying pins for data saved in annotation array with coordinates
        
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
            
            guard let annotation = view.annotation else {
                return
            }
            guard var subtitle = annotation.subtitle else {
                return
            }
            
            
            if subtitle!.isValidURL {
                if subtitle!.starts(with: "www") {
                    subtitle! = "https://" + subtitle!
                }
                let url = URL(string: subtitle!)
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        _ = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
}

// MARK: URL validator. Checks if string is nil, has random characters or is empty

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
