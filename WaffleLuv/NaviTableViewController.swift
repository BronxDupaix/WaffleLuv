//
//  NaviTableViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class NaviTableViewController: UITableViewController {
    
    var instaApi = Instagram()
    
    var calendarApi = CalendarAPI()
    
    var locationsView = LocationsViewController()
    
    @IBOutlet weak var waffleLoveImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instaApi.fetchInstaPhotos()
        
        calendarApi.fetchCalendar()

        
        print("Hello")
    }

  

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 5 {
            
            return 600
        }
        
        return 40
    }
}
