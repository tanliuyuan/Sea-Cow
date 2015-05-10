//
//  readArticle.swift
//  seaCow
//
//  Created by Scott Gavin on 5/7/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class readArticle: NSObject, NSCoding {
   
    var title: String!
    var url: String!
    // MARK: NSCoding
    
    override init() {}
    
    required init(title2: String, url2: String) {
        self.title = title2
        self.url = url2
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObjectForKey("title") as! String?
        self.url = decoder.decodeObjectForKey("url") as! String?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.url, forKey: "url")
    }
    


}
