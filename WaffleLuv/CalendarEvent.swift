//
//  CalendarEvent.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/6/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class CalendarEvent {
    
    
    var location = String()
    
    var startDate = NSDate()
    
    var endDate = NSDate()
    
    var latitiude: Double = 0.00
    
    var longitude: Double = 0.00 
    
    let dateFormatter = NSDateFormatter()
    
    init() {
        
    }
    
    init(dict: JSONDictionary) {
        
        
        if let location = dict["location"] as? String {
            
            self.location = location

        } else {
            
          //  print("Couldnt parse location")
        }
        
        if let startDate = dict["start"] as? JSONDictionary{
            
            if let dateString = startDate["dateTime"] as? String {
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

                if let date = dateFormatter.dateFromString(dateString) {
                    
                    self.startDate = date

                } else {

                }
            }
            
        } else {
            
          //  print("Couldnt pass startDate")
        }
        
        if let endDate = dict["end"] as? JSONDictionary {
            
            if let endDateString = endDate["dateTime"] as?
                String  {
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                
                if let date = dateFormatter.dateFromString(endDateString) {
                    
                    self.endDate = date

                }
                
                
            }
        } else {
  
        }
        
        
    }
    

    
    
    
    
}