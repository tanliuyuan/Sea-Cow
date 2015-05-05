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
    
}
