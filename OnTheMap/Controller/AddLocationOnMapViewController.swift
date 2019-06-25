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
    
    var addressProvidedbyTheUser: String?
    var nameToMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapRecognizer(sender:)))
        mapView.addGestureRecognizer(longTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if nameToMap == true, addressProvidedbyTheUser != nil {
            print(addressProvidedbyTheUser!)
            nameToLocation(addressProvidedbyTheUser!) { (coordinate, error) in
                guard let error = error else {
                    print("coordinates from name: \(coordinate)")
                    return
                }
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    @objc func longTapRecognizer(sender: UIGestureRecognizer){
        print("long tap")
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
    
    // Call function... decide when to use customer data...
    
    func addAnnotation(location: CLLocationCoordinate2D){
        
        let annotation = MKPointAnnotation()
        
        locationToName(location: location) { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }
            let stringArr = String(describing: data)
            let separated = stringArr.components(separatedBy: ",")
            annotation.title = separated[0]
            annotation.subtitle = separated[2]
        }
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
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
