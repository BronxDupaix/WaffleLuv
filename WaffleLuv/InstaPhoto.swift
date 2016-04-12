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

    init(){
    }
    
    init(dict: JSONDictionary) {
        
        if let url = dict["url"] as? String {
            
            
            self.url = url
            
          //  print(url)
        } else {
            
            print("Couldnt parse url")
        }
        
    }
    
    
}