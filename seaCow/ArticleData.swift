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
 
    func encode(with coder: NSCoder) {
        //println("trying to encode in article data...")
        coder.encode(title, forKey: "title")
        coder.encode(imageUrl, forKey: "imageUrl")
        coder.encode(url, forKey: "url")
        coder.encode(section, forKey: "section")
        //println("done")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        //println("In init")
        title = aDecoder.decodeObject(forKey: "title") as! String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String
        url = aDecoder.decodeObject(forKey: "url") as! String
        section = aDecoder.decodeObject(forKey: "section") as! String
        //println(title + " " + imageUrl + " " + url + " " + section)
    }
    
}
