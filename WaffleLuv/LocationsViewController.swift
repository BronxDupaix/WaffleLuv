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
import WebKit

class LocationsViewController: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate {

    //MARK: - Variables
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    @IBOutlet weak var locationsMap: MKMapView!
    
    let initialLocation = CLLocation(latitude: 40.760779, longitude: -111.891047) 
    
    let regionRadius: CLLocationDistance = 700000
    
    var currentEvents = [CalendarEvent]()
    
    var dateFormatter = NSDateFormatter()
    
    var webView = WKWebView()
    
    //MARK: - View did functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Map view did load")

        for event in DataStore.sharedInstance.currentEvents {

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
        regionRadius * 1.0, regionRadius * 1.0)
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
            
           // print(coordinate?.latitude)
           // print(coordinate?.longitude)
            
            if let center = coordinate {
                
               let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7))
                
               self.locationsMap.setRegion(region, animated: true)
                
                let currentLocation = MKPointAnnotation()
                
                currentLocation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
                
                currentLocation.title = "Your current location"

                self.locationsMap.showsUserLocation = true
                
                print("mapview updated")
                
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let location = view.annotation!.title {
            
            if let time = view.annotation!.subtitle {
                
                self.directionsToLocation(location!, time: time!)
            }
            
            
        }
    }
    
    //MARK: - MKPins function

    
    func createMKPins(event: CalendarEvent) {
        
        let truck = CustomPointAnnotation()
        
        truck.imageName = "truck" 
        
        truck.coordinate = CLLocationCoordinate2D(latitude: event.latitiude, longitude: event.longitude)
        
        truck.title = event.location
        
        dateFormatter.dateFormat = "hh:mm a"
        
        let start = dateFormatter.stringFromDate(event.startDate)
        let end = dateFormatter.stringFromDate(event.endDate)
        
        truck.subtitle = "\(start) - \(end)"
        
        locationsMap.addAnnotation(truck)
        
        let midvale = CustomPointAnnotation()
        
        let provo = CustomPointAnnotation()
        
        let bountiful = CustomPointAnnotation()
        
        let gilbert = CustomPointAnnotation() 
        
        gilbert.coordinate = CLLocationCoordinate2D(latitude: 33.300539, longitude: -111.743183)
        
        gilbert.imageName = "store"
        
        gilbert.title = "2743 S Market St #104, Gilbert, AZ 85295"
        
        gilbert.subtitle = "Gilbert AZ Location"
        
        midvale.coordinate = CLLocationCoordinate2D(latitude: 40.623698, longitude: -111.860071)
        
        midvale.imageName = "store"
        
        midvale.title =  "1142 Fort Union Blvd #M05, Midvale, UT 84047"
        
        midvale.subtitle = "Midvale Location"

        provo.coordinate = CLLocationCoordinate2D(latitude: 40.258434, longitude: -111.674773)
        
        provo.imageName = "store"
        
        provo.title = "1796 N 950 W St, Provo, UT 84604"
        
        provo.subtitle = "Provo Location"
        
        bountiful.coordinate = CLLocationCoordinate2D(latitude: 40.891752, longitude: -111.892615)
        
        bountiful.imageName = "store"
        
        bountiful.title =  "255 North 500 West, Bountiful, UT 84010"
        
        bountiful.subtitle = "Bountiful Location"
        
        centerMapOnLocation(initialLocation)
        
        locationsMap.addAnnotation(midvale)
        
        locationsMap.addAnnotation(provo)
        
        locationsMap.addAnnotation(bountiful)
        
        locationsMap.addAnnotation(gilbert)
        
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        

        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            
                        let truckImage = UIImageView(frame: CGRectMake(0, 0, 30, 30))
            
                        truckImage.image = UIImage(named: "store") 
            
                        annotationView!.image = truckImage.image
            
            annotationView!.rightCalloutAccessoryView = detailButton
        }
        else
        {
            
            
            annotationView!.annotation = annotation
        }
        
        let cpa = annotation as? CustomPointAnnotation
        
        annotationView!.image = UIImage(named:cpa!.imageName)
        
        return annotationView
    }
    
    //MARK: - Directions Alert View
    
    func directionsToLocation(location: String, time: String ) {
        
        print("Annotation Tapped")

        let alertController = UIAlertController(title: "\(location) (\(time))", message: "Take Me To This Location", preferredStyle: .Alert)

        let directionsAction = UIAlertAction(title: "Directions", style: .Default) { (alertAction) -> Void in
            
            print("Directions Pressed")
            
            let urlString = "https://www.google.com/maps/place/\(location)"
            
            let safeURL = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            let url = NSURL(string: safeURL!)
            
            let nsurl = NSURLRequest(URL: url!)
            
            self.webView.loadRequest(nsurl)
            
            self.webView.backgroundColor = UIColor .redColor()
            
            self.view.addSubview(self.webView)
            
            let frame = CGRectMake(0, 60, self.view.bounds.width, self.view.bounds.height-60)
            
            self.webView.frame = frame
            
            self.view.bringSubviewToFront(self.webView)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alertAction) -> Void in
            
            print("CancelledPressed")
        }

        alertController.addAction(directionsAction)
        
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion:nil)
  
    }
}
