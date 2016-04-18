//
//  InstaPhoto.swift
//  InstagramJsonSample-Swift
//
//  Created by Bronson Dupaix on 4/11/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class InstaPhoto {
    
    var url: String = ""
 
    var image: UIImage?

    init(){
    }
    
    func convertUrl (urlString: String) {
        
        if urlString.isEmpty == false {
            
            dispatch_async(dispatch_get_main_queue(), {
                if let url = NSURL(string: urlString) {
                    if let data = NSData(contentsOfURL: url) {

                       self.image = UIImage(data: data)!
  
                    }
                }
            })
        } else {
            debugPrint("Invalid \(urlString)")
        }
    }
    
    
    
    init(dict: JSONDictionary) {
        
        if let url = dict["url"] as? String {
            
            self.url = url
            
            convertUrl(url)

        } else {
            
            print("Couldnt parse url")
        }
        
    }
    
    
}