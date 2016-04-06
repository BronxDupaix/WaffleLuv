//
//  WaffleMenuViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class WaffleMenuViewController: UIViewController {

  
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var calendarApi = CalendarAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarApi.fetchCalendar() 
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }


    @IBAction func navButtonTapped(sender: UIBarButtonItem) {
        
        print("Nav Button Tapped")
    }
 

}
