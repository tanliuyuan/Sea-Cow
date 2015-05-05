//
//  ArticleData.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/21/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import UIKit

class ArticleData: NSObject {
    
    var title: String
    var imageUrl: String
    var url: String
    
    override init() {
        self.title = ""
        self.imageUrl = ""
        self.url = ""
    }
    
    init(forTitle: String, forUrl: String, forImageUrl: String) {
        self.title = forTitle
        self.imageUrl = forImageUrl
        self.url = forUrl
    }
    
}
