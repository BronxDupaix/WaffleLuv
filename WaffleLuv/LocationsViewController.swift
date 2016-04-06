//
//  LocationsViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationsViewController: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    @IBOutlet weak var locationsMap: MKMapView!
    
    let initialLocation = CLLocation(latitude: 40.760779, longitude: -111.891047) 
    
    let regionRadius: CLLocationDistance = 66000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(initialLocation)

        
        if self.revealViewController() != nil {
            navButton.target = self.revealViewController()
            navButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        locationsMap.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        print("didChangeAuthStatus")
        
        switch(status) {
        case.NotDetermined: print("I dont know if I have Permission")
        case.AuthorizedWhenInUse: print("Authorized when in use")
        case.AuthorizedAlways: print("Always Authorized")
        case.Denied: print("denied")
        default: print("other Auth")
        }
        
        if status != .Denied{
            manager.requestLocation()
        }
        
        print("Did Change Auth Status")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let l = locations.first
            
            let coordinate = l?.coordinate
            
            print(coordinate?.latitude)
            print(coordinate?.longitude)
            
            
            if let center = coordinate {
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.locationsMap.setRegion(region, animated: true)
                self.locationsMap.showsUserLocation = true
                
                print("mapview updated")
                
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }


}
