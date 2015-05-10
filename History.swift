//
//  History.swift
//  seaCow
//
//  Created by Scott Gavin on 5/10/15.
//  Copyright (c) 2015 Sea Cow. All rights reserved.
//

import UIKit

class History: NSObject {
    var allArticles: [readArticle] = []
    
    override init() {
        println("History initialized")
    }
    
    required init(coder decoder: NSCoder) {
        self.allArticles = decoder.decodeObjectForKey("allArticles") as! [readArticle]
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.allArticles, forKey: "allArticles")
    }
    
    func addArticle(article: ArticleData) {
        allArticles.append(readArticle(title2: article.title, url2: article.url))
    }
    
    func save() {
        println("trying to save")
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        println("data created, trying to write")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "history")
        println("success")
    }
    
    func load() -> Bool {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("history") as? NSData {
            let temp = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! History
            allArticles = temp.allArticles
            println("History Loaded")
            return true
        }
        return false
    }

    //returns true if it exists
    func checkIfExists(articleName: String) -> Bool {
        var i = 0
        println(allArticles.count)
        for(i=0; i < allArticles.count; i++) {
          //  println(articleName)
            if(articleName == allArticles[i].title) {
                println("Returning true")
                return true
            }
        }
        return false
    }
}
