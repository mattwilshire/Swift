//
//  ViewController.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 02/04/2022.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let map = MKMapView()
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
        map.frame = view.frame
        view.addSubview(map)
    }
    
    override func viewDidLayoutSubviews() {
//        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
//            print("Pressed Cancel")
//        }))
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            print("Pressed Ok")
//        }))
//
//        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization() {
        // Location services is off for the entire device ?
        if CLLocationManager.locationServicesEnabled() {
            setupLocationServices()
            checkLocationAuthorized()
        } else {
            // Tell them location services needs to be on
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
        }
    }

    func checkLocationAuthorized() {
        let authStatus: CLAuthorizationStatus
        
        // CLLocationManager.authorizationStatus() is depreceated in iOS 14 so check if iOS is lower than 14 for this request
        if #available(iOS 14, *) {
            authStatus = locationManager.authorizationStatus
        } else {
            authStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted, .denied:
                // Popup to tell them how to turn it back on
                break
            case .authorizedAlways, .authorizedWhenInUse:
                centerViewOnUserLocation()
                map.showsUserLocation = true
                break
            @unknown default:
                print("Unknown value supplied.")
        }
    }
}

