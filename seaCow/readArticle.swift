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
        self.title = decoder.decodeObject(forKey: "title") as! String?
        self.url = decoder.decodeObject(forKey: "url") as! String?
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.url, forKey: "url")
    }
    


}
