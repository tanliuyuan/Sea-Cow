//
//  ArticleData.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/21/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import UIKit
import Foundation

class ArticleData: NSObject, NSCoding {
    
    var title: String
    var imageUrl: String
    var url: String
    var section: String
    
    
    
    override init() {
        self.title = ""
        self.imageUrl = ""
        self.url = ""
        self.section = ""
    }
    
    init(forTitle: String, forUrl: String, forImageUrl: String, forSection: String) {
        self.title = forTitle
        self.imageUrl = forImageUrl
        self.url = forUrl
        self.section = forSection
    }
 
    func encodeWithCoder(coder: NSCoder) {
        println("trying to encode in article data...")
        coder.encodeObject(title, forKey: "title")
        coder.encodeObject(imageUrl, forKey: "imageUrl")
        coder.encodeObject(url, forKey: "url")
        coder.encodeObject(section, forKey: "section")
        println("done")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        println("In init")
        title = aDecoder.decodeObjectForKey("title") as! String
        imageUrl = aDecoder.decodeObjectForKey("imageUrl") as! String
        url = aDecoder.decodeObjectForKey("url") as! String
        section = aDecoder.decodeObjectForKey("section") as! String
        println(title + " " + imageUrl + " " + url + " " + section)
    }
    
}
