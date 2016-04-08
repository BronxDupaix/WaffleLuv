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


//MARK: - Event Protocol

protocol EventProtocol{
    
    func passEvent(eventsArray: [CalendarEvent]) 
    
}

class LocationsViewController: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    //MARK: - Variables
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    @IBOutlet weak var locationsMap: MKMapView!
    
    let initialLocation = CLLocation(latitude: 40.760779, longitude: -111.891047) 
    
    let regionRadius: CLLocationDistance = 700000
    
    var currentEvents = [CalendarEvent]()
    
    var dateFormatter = NSDateFormatter()
    
    //MARK: - View did functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Map view did load")
        
        for event in DataStore.sharedInstance.currentEvents {
            
            
            print(event.location)
            
            print(event.latitiude)
            
            print(event.longitude)
            
            
            createMKPins(event)
        }
        
       

        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
        if self.revealViewController() != nil {
            navButton.target = self.revealViewController()
            navButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        locationsMap.showsUserLocation = true
    }
    
    
    //MARK: - Locations Manager functions and Center map
    
    
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
                
               let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7))
                
               self.locationsMap.setRegion(region, animated: true)
                
                let currentLocation = MKPointAnnotation()
                
                currentLocation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
                
                currentLocation.title = "Your current location"
                
                self.locationsMap.addAnnotation(currentLocation)
                
                self.locationsMap.showsUserLocation = true
                
                print("mapview updated")
                
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    
    
       
    
    //MARK: - MKPins function

    
    func createMKPins(event: CalendarEvent) {
        
        let truck = MKPointAnnotation()
        
        truck.coordinate = CLLocationCoordinate2D(latitude: event.latitiude, longitude: event.longitude)
        
        truck.title = event.location
        
        dateFormatter.dateFormat = "hh:mm a"
        
        let start = dateFormatter.stringFromDate(event.startDate)
        let end = dateFormatter.stringFromDate(event.endDate)
        
        truck.subtitle = "\(start) - \(end)"
        
        locationsMap.addAnnotation(truck)
        
        let midvale = MKPointAnnotation()
        
        let provo = MKPointAnnotation()
        
        let bountiful = MKPointAnnotation()
        
        let gilbert = MKPointAnnotation()
        
        gilbert.coordinate = CLLocationCoordinate2D(latitude: 33.300539, longitude: -111.743183)
        
        gilbert.title = "Gilbert AZ Location"
        
        gilbert.subtitle = "2743 S Market St #104, Gilbert, AZ 85295"
        
        midvale.coordinate = CLLocationCoordinate2D(latitude: 40.623698, longitude: -111.860071)
        
        midvale.title = "Midvale Location"
        
        midvale.subtitle = "1142 Fort Union Blvd #M05, Midvale, UT 84047"

        provo.coordinate = CLLocationCoordinate2D(latitude: 40.258434, longitude: -111.674773)
        
        provo.title = "Provo Location"
        
        provo.subtitle = "1796 N 950 W St, Provo, UT 84604"
        
        bountiful.coordinate = CLLocationCoordinate2D(latitude: 40.891752, longitude: -111.892615)
        
        bountiful.title = "Bountiful Location"
        
        bountiful.subtitle = "255 North 500 West, Bountiful, UT 84010"
        
        centerMapOnLocation(initialLocation)
        
        locationsMap.addAnnotation(midvale)
        
        locationsMap.addAnnotation(provo)
        
        locationsMap.addAnnotation(bountiful)
        
        locationsMap.addAnnotation(gilbert)
    }

}
