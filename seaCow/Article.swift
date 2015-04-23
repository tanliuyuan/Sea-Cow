//
//  Article.swift
//  seaCow
//
//  Created by Tim Van Horn on 4/23/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit


class Article: NSObject {
    
    var title: String
    var section: String
    var url: String
    var image_url: String
    
    init(title:String, section:String, url:String, image_url:String) {
        self.title = title
        self.section = section
        self.url = url
        self.image_url = image_url
    }
    
    
}