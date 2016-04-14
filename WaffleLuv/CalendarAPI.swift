//
//  CalendarApi.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/6/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String:AnyObject]
typealias JSONArray = [JSONDictionary]

class CalendarAPI {
    
    let calendarIDs = ["37acdbblsoobtn4e8pdiiou0og","7le3v0i298umv73s6utg6mlgns","vedof0bnd56tpg88ts26ri8tfs", "ljtm924o1d2i1rsvcasfifa8v0", "cv3ksjlpccbinsdskl03sje1uk","a4qf72ifpil5ubisui5krs6o6s"] 
    
    var events = [CalendarEvent]()
    
    var currentEvents = [CalendarEvent]()
    
    var currentDate = NSDate()
    
    var dateFormatter = NSDateFormatter()

    
    func checkForCurrentEvents(item: CalendarEvent)  {
       // print("Number of items in array \(events.count)")
        
            let endTime = item.endDate
            
            let end = endTime.timeIntervalSince1970
            
           // print("End time=\(end)")
            
            let today = currentDate.timeIntervalSince1970
            
           // print("Todays time\(today)")
            
            let startTime = item.startDate
            
            let start = startTime.timeIntervalSince1970
            
           // print("Start time =\(start)")
            
            if start <= today {
                
             //   print("Start time checked")
                
                if end >= today {
                    
                  //  filteredArray.append(item)
                    
                    if item.location != "" {
                    
                   // print(item.location)
                    
                   // print(item.startDate)
                    
                   //
                        print(item.endDate)
                    
                    print("item appended")
                        
                        
                        DataStore.sharedInstance.currentEvents.append(item)
                        
                        DataStore.sharedInstance.numberOFEvents()
                        
                        DataStore.sharedInstance.geocodeLocations()
                    }
                    
                }
                
            }
            
            
        

    }
    
    
    func fetchCalendar() {
        
        print("Fetch calendar called") 
        
        for id in calendarIDs {
        
        let urlString = "https://www.googleapis.com/calendar/v3/calendars/\(id)@group.calendar.google.com/events?key=AIzaSyA6hNF8nwtP3iCRa72yFJIhWbjWUfw0rvw&maxResults=9999"
        
        if let url = NSURL(string: urlString)
        {
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: {
                
                (data, response, error) -> () in
                
                if error != nil {
                    debugPrint("an error occured \(error)")
                }else {
                    
                    
                    //  print(data)
                    
                    if let data = data {
                        
                        do {
                            
                            if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONDictionary {
                                
                                // print(dictionary)
                                
                                if let items = dictionary["items"] as? JSONArray {
                                    
                                    for item in items {
                                        
                                        let event = CalendarEvent(dict: item)
                                        
                                        self.checkForCurrentEvents(event)
                                        
                                        // Pass each individual event into the checkForCurrentEvents and check to see if it meets the requirements?
                                    }
                                }
                                
                                
                            } else {
                                debugPrint("cant parse dictionary")
                            }
                            
                        } catch {
                            
                            debugPrint("cant parse JSON")
                            
                        }
                    }
                }
                
            })
            
            task.resume()
            
            
            
        } else {
            debugPrint("cant print data")
        }
            
        }
        
    }
    
    func fetchSaltLakeTruck1() {
        
        
        
    }
    
    
}