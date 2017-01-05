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
        print("History initialized")
    }
    
    required init(coder decoder: NSCoder) {
        self.allArticles = decoder.decodeObject(forKey: "allArticles") as! [readArticle]
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.allArticles, forKey: "allArticles")
    }
    
    func addArticle(_ article: ArticleData) {
        allArticles.append(readArticle(title2: article.title, url2: article.url))
    }
    
    func save() {
        print("trying to save")
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        print("data created, trying to write")
        UserDefaults.standard.set(data, forKey: "history")
        print("success")
    }
    
    func load() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "history") as? Data {
            let temp = NSKeyedUnarchiver.unarchiveObject(with: data) as! History
            allArticles = temp.allArticles
            print("History Loaded")
            return true
        }
        return false
    }

    //returns true if it exists
    func checkIfExists(_ articleName: String) -> Bool {
        var i = 0
        for(i=0; i < allArticles.count; i += 1) {
          //  println(articleName)
            if(articleName == allArticles[i].title) {
                //println("Article already read")
                return true
            }
        }
        return false
    }
}
