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
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var addressProvidedbyTheUser: String?
    var nameToMap = false
    let userPin = MKPointAnnotation()
    
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapRecognizer(sender:)))
        mapView.addGestureRecognizer(longTap)
        textField.delegate = self
        self.navigationItem.title = "Long press to select your location"
        
    }
    

    // MARK: Network connection callers for POST and PUT
    
    func networkConnection(completion: @escaping (Bool) -> Void){
    
        // If user hasn't uploaded his location before flag is set to false and the POST method is called
        
        if !Flag.dataSubmitted {
            APIRequests.postStudentLocation(userGatheredData: StorageController.user) { (data, error) in
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    completion(false)
                    return
                }
                print("post response")
                Flag.dataSubmitted = true
                StorageController.postResponse = data
                
                completion(true)
                
            }
            
            // If user already uploaded his location flag is set to true. If on top of that data in the app are available Update method is called
            
        } else {
            guard let data = StorageController.postResponse else {
                completion(false)
                return
            }
                APIRequests.updateStudentLocation(objectID: data.objectId, userGatheredData: StorageController.user) { (success: Bool, error: Error?) in
                if success {
                    print("user data updated")
                    completion(true)
                }
                print(error?.localizedDescription ?? "")
            }
        }
        
    }

    
    @IBAction func submitTapped(sender: UIButton) {
        
        if blurEffect.isHidden {
            StorageController.user.latitude = userPin.coordinate.latitude
            StorageController.user.longitude = userPin.coordinate.longitude
    
            print(StorageController.user)
            textFieldAnimation(true)
        } else {
            textField.endEditing(true)
            print(String(describing: StorageController.user))
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultView") as! ResultViewController
          
            networkConnection { (success) in
                vc.status(success)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        textFieldAnimation(false)
    }
    
    //MARK: Alert to be displayed if something went wrong.
    
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
        blurEffect.isHidden = true
        textField.isHidden = true
        cancelButton.isHidden = true
        
        // MARK: If user typed the address, then it is converted into coordinates which are used to display the desired area on the map, so the user could easily select desired spot.
        
        if nameToMap == true, addressProvidedbyTheUser != nil {
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
    
    // MARK: When user selects desired location, he will see details of the placemark under the pin dropped on the map
    
    func locationToName(location: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?, Error?) -> Void){
        let loc = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemarks = placemarks else {
                print(error?.localizedDescription ?? "")
                completionHandler(nil, error)
                return
            }
            let placemark = placemarks[0]
            completionHandler(placemark, nil)
        })
    }
    
    // MARK : address provided by the user is being translated into the locaation coordinates
    
    func nameToLocation(_ locationName: String, completionHandler: @escaping (CLLocationCoordinate2D, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            guard let placemarks = placemarks else {
                completionHandler(kCLLocationCoordinate2DInvalid, error)
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ResultView") as! ResultViewController
                vc.status(false)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            let placemark = placemarks[0]
            if let location = placemark.location {
                completionHandler(location.coordinate, nil)
                return
            }
        }
    }
    
    // MARK : Annotations.
        // Dropped pin displays information about the place like city (administrative area) and street name
    
    func addAnnotation(location: CLLocationCoordinate2D){
        
        mapView.removeAnnotation(userPin)
        locationToName(location: location) { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if let city = data.administrativeArea {
                StorageController.user.mapString = city
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
        
        buttonAnimation()
    }
    
    //MARK: Animations
    
    
    // Submit button appears when user drop a pin on the map. If button is already visible it will pulse
    
    func buttonAnimation() {
        if !submitLocation.isHidden {
            
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
    
    func textFieldAnimation(_ start: Bool) {
        if start {
            self.blurEffect.alpha = 0
            self.blurEffect.isHidden = false
            self.textField.alpha = 0
            self.textField.isHidden = false
            self.cancelButton.alpha = 0
            self.cancelButton.isHidden = false
            

            UIView.animate(withDuration: 1.0,
                           delay: 0.5,
                           options: .curveEaseIn,
                           animations: {
                            self.blurEffect.alpha = 1
                            self.textField.alpha = 1
                            self.cancelButton.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 1.0,
                           delay: 0.5,
                           options: .curveLinear,
                           animations: {
                            self.blurEffect.alpha = 0
                            self.textField.alpha = 0
                            self.cancelButton.alpha = 0
            }, completion: nil)
            
        }
    }
}



extension AddLocationOnMapViewController: MKMapViewDelegate, UITextFieldDelegate {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textFieldAnimation(false)
        StorageController.user.mediaURL = textField.text ?? " "
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        StorageController.user.mediaURL = textField.text ?? " "
    }
    
}


