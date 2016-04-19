//
//  Datastore.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/7/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

import CoreLocation

class DataStore: NSObject {
    
    static let sharedInstance = DataStore()
    
    private override init() {}
    
    var currentEvents = [CalendarEvent]()
    
    var instaPhotos = [InstaPhoto]()

    //MARK: - Events Functions
    
    func numberOFEvents() {
        
        print("Number of events in datastore \(currentEvents.count)")
    }
    
    func geocodeLocations()  {
        
        // print("Geocoding location")
        
        for event in currentEvents {
            
            geocoding(event.location)  {
                
                (latitude: Double, longitude: Double) in
                
                let lat: Double = latitude
                
                event.latitiude = lat

                let long: Double = longitude
                
                event.longitude = long
                
                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationEventGeocode, object: nil) 
               //  print(event.location)
            }
        }
    }
    
    func geocoding(location: String, completion: (Double, Double) -> ()) {
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark!.location
                let coordinate = location?.coordinate
                completion((coordinate?.latitude)!, (coordinate?.longitude)!)
            }
        }
    }

    
}