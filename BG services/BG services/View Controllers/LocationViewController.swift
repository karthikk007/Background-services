//
//  LocationViewController.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class LocationViewController: UIViewController {
    
    let accuracyValues = [      kCLLocationAccuracyBestForNavigation,
                                kCLLocationAccuracyBest,
                                kCLLocationAccuracyNearestTenMeters,
                                kCLLocationAccuracyHundredMeters,
                                kCLLocationAccuracyKilometer,
                                kCLLocationAccuracyThreeKilometers]
    
    var locations: [MKPointAnnotation] = []
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        
        return manager
    }()
    
    let locationUpdateSwitch: UISwitch = {
        let locationSwitch = UISwitch()
        
        locationSwitch.addTarget(self, action: #selector(didChangeLocationSwitch(sender:)), for: .valueChanged)
        locationSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return locationSwitch
    }()
    
    let accuracyView: UISegmentedControl = {
        let items = Constants.LocationAccuracy.list
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(didChangeAccuracy(sender:)), for: .valueChanged)
        
        return segmentedControl
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .random()
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(accuracyView)
        view.addSubview(locationUpdateSwitch)
        
        accuracyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        accuracyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        accuracyView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        accuracyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        locationUpdateSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        locationUpdateSwitch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        locationUpdateSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationUpdateSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        didChangeAccuracy(sender: accuracyView)
    }
    
    @objc func didChangeAccuracy(sender: UISegmentedControl) {
        print("accuracy view selected index = \(sender.selectedSegmentIndex)")
        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex]
    }
    
    @objc func didChangeLocationSwitch(sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = latestLocation.coordinate

        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while self.locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(self.locations, animated: true)
        } else {
            print("location background: new location = \(latestLocation) count = \(self.locations.count)")
        }
    }
}
