//
//  photoCollectionViewCell.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/11/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

import QuartzCore

class photoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var imageBackground: UIView!
    
    
    func loadImageFromURL(urlString: String) {
        
        if urlString.isEmpty == false {
            
            dispatch_async(dispatch_get_main_queue(), {
                if let url = NSURL(string: urlString) {
                    if let data = NSData(contentsOfURL: url) {
                        
                        self.photo.image = UIImage(data: data)
                    }
                }
            })
        } else {
            debugPrint("Invalid \(urlString)")
        }
    }

    
    
    
}
