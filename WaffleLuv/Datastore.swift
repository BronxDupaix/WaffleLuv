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
    
    var currentTime = NSDate()

    //MARK: - Events Functions
    
    func numberOFEvents() {
        
        print("Number of events in datastore \(currentEvents.count)")
    }
    
    func geocodeLocations()  {

        for event in currentEvents {
            
            geocoding(event.location)  {
                
                (latitude: Double, longitude: Double) in
                
                let lat: Double = latitude
                
                event.latitiude = lat
        
                let long: Double = longitude
                
                event.longitude = long
                
                print(" Calling notification event") 

                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationEventGeocode, object: nil)
      
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
    
    
    func removeOldEvents(){
        
        let time = currentTime.timeIntervalSince1970
        
        for event in currentEvents{
            
            let eventEnd = event.endDate.timeIntervalSince1970
            
            if eventEnd <= time {
                
            }
            
        }
    }
    
}