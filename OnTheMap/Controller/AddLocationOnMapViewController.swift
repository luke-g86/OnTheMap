//
//  AddLocationOnMapViewController.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationOnMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitLocation: ButtonsDesign!
    
    var addressProvidedbyTheUser: String?
    var nameToMap = false
    let userPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapRecognizer(sender:)))
        mapView.addGestureRecognizer(longTap)
        
    }
    
    
    func alert() {
        let alert = UIAlertController(title: "Sorry, no results", message: "No address found, please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController")
            self.present(addLocationViewController!, animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        submitLocation.isHidden = true
        if nameToMap == true, addressProvidedbyTheUser != nil {
            print(addressProvidedbyTheUser!)
            nameToLocation(addressProvidedbyTheUser!) { (location, error) in
                guard let error = error else {
                    print("coordinates from name: \(location)")
                    
                    let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.mapView.setRegion(region, animated: true)
                    
                    return
                }
                print(error.localizedDescription)
                self.alert()
            }
            
        }
    }
    
    
    @objc func longTapRecognizer(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
            
        }
    }
    
    
    func locationToName(location: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?, Error?) -> Void){
        let loc = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemarks = placemarks else {
                print(error?.localizedDescription)
                completionHandler(nil, error)
                return
            }
            let placemark = placemarks[0]
            completionHandler(placemark, nil)
        })
    }
    
    func nameToLocation(_ locationName: String, completionHandler: @escaping (CLLocationCoordinate2D, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            guard let placemarks = placemarks else {
                completionHandler(kCLLocationCoordinate2DInvalid, error)
                return
            }
            let placemark = placemarks[0]
            if let location = placemark.location {
                completionHandler(location.coordinate, nil)
                return
            }
        }
    }
    
    
    func addAnnotation(location: CLLocationCoordinate2D){
        
        mapView.removeAnnotation(userPin)
        
        locationToName(location: location) { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }
            let stringArr = String(describing: data)
            let separated = stringArr.components(separatedBy: ",")
            self.userPin.title = separated[0]
            self.userPin.subtitle = separated[2]
        }
        userPin.coordinate = location
        mapView.addAnnotation(userPin)
        
        let region = MKCoordinateRegion(center: userPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
        
        buttonAnimation(submitLocation, submitLocation.isHidden)
    }
    
    func buttonAnimation(_ object: NSObject, _ activityFlag: Bool) {
        if !activityFlag {
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.5
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 1
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            
            submitLocation.layer.add(pulse, forKey: nil)
            
        } else {
            submitLocation.isHidden = false
            submitLocation.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.submitLocation.transform = .identity }, completion: nil)
            
        }
    }
}



extension AddLocationOnMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.green
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                print("do something")
            }
        }
    }
}
