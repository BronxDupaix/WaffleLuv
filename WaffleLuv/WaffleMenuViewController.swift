//
//  WaffleMenuViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class WaffleMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var waffleMenu: UITableView!
    
    var calendarApi = CalendarAPI()
    
    var instaApi = Instagram()
    
    var wafflesArray = [Waffle]()

    //MARK: - View Did load 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarApi.fetchCalendar()
        
        instaApi.fetchInstaPhotos() 
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let (jsonString, data) = loadJSONFile("Waffles", fileType: "json")
        
       // print(jsonString)
        
        if let jsondata = data {
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(jsondata, options: .AllowFragments)
                
                if let dict = object as? JSONDictionary {
                    
                    if let waffles = dict["waffles"] as? JSONArray{
                        
                        for waffle in waffles{
                    
                            
                            let waffle = Waffle(dict: waffle)
                    
                            wafflesArray.append(waffle)
                            
                        }
                    }
                }
            } catch {
                
                print("Data Error - Unable to parse the original jsonString")
            }
        }

        
        
    } // End of View did load
    
    
    //MARK: - TableView functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let waffle = wafflesArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("waffleCell") as!WaffleTableViewCell
        
        if waffle.name == "Daily Special" {
            
            cell.nameLabel.textColor = UIColor.whiteColor()
        }
        
        if waffle.name == "Plain Liege" {
            
            cell.nameLabel.textColor = UIColor.cyanColor()
        }
        
        if waffle.name == "The Churro Waffle"{
            
            let color = MyColors.getCustomlightPurpleColor()
            
            cell.nameLabel.textColor = color
        }
        
        if waffle.name == "The Cinna Love" {
            
            let color = MyColors.getCustomPinkColor()
            
            cell.nameLabel.textColor = color
            
        }
        
        if waffle.name == "The Red Wonder" {
            
            let color = MyColors.getCustomRedColor()
            
            cell.nameLabel.textColor = color
            
            cell.wafflePhoto.image = UIImage(named: "RedWonder")
        }
        
        if waffle.name == "The Works" {
            
            let color = MyColors.getCustomCreamColor()
            
            cell.nameLabel.textColor = color
            
            cell.wafflePhoto.image = UIImage(named: "WaffleWorks") 
        }
        
        if waffle.name == "Nutella Love" {
            
            cell.nameLabel.textColor = UIColor .brownColor()
            
            cell.wafflePhoto.image = UIImage(named: "NutellaLove")
                
        }
        
        if waffle.name == "Banana Cream Pie" {
            
            let color = MyColors.getCustomBananaColor() 
            
            cell.nameLabel.textColor = color
        }
        
        if waffle.name == "The Sunshine" {
            
            
            let color = MyColors.getCustomYellowColor()
            
            cell.nameLabel.textColor = color 
        }
        
        
        if waffle.name == "Dulce de Liege" {
            
            let color = MyColors.getCustomBlueGreenColor()
            
            cell.nameLabel.textColor = color
            
            cell.wafflePhoto.image = UIImage(named: "TheDulce")
        }
        
        if waffle.name == "Date Waffle" {
            
            let color = MyColors.getCustomPurpleColor()
            
            cell.nameLabel.textColor = color
            
        }

        if waffle.name == "Grill Cheese & Bisque"{
            
            let color = MyColors.getCustomOrangeColor()
            
            cell.nameLabel.textColor = color
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.nameLabel.text = waffle.name
        
        cell.descriptionLabel.text = waffle.description
        
        cell.priceLabel.text = waffle.price 
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wafflesArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       let waffle = wafflesArray[indexPath.row]
        
        toggleWaffle(waffle)
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let waffle = wafflesArray[indexPath.row]
        
        if waffle.isSelected == true {
            
            return 150
            
        } else {
            
            return 35
        }
    }
    
    func toggleWaffle(waffle: Waffle) {
        
        waffle.isSelected = !waffle.isSelected
        
        self.waffleMenu.beginUpdates()
        
        self.waffleMenu.endUpdates()
    }
    
    
    //MARK: - Load JSON
    
    func loadJSONFile(filename: String, fileType: String) -> (String, NSData?) {
        
        var returnString = ""
        var data: NSData? = nil
        
        guard let filePath = NSBundle.mainBundle().URLForResource(filename, withExtension: fileType) else { return (returnString, data) }
        
        if let jsondata = NSData(contentsOfURL: filePath) {
            if let jsonString = NSString(data: jsondata, encoding: NSUTF8StringEncoding) {
                returnString = jsonString as String
                data = jsondata
            }
        }
        return (returnString, data)
    }
    

 

} // End of View Controller
