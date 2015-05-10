//
//  ReadingList.swift
//  seaCow
//
//  Created by Scott Gavin on 5/7/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit
import Foundation

class ReadingList: NSObject , NSCoding {
    var articles: [ArticleData]! = []
    override init() {
        println("Initalizing Reading List")
    }
    
    func addArticle(article: ArticleData) {
        println("Adding article")
        articles.append(article)
        
    }
    
    func removeArticle(index: Int) {
        println("Removing article")
        articles.removeAtIndex(index)
    }
    
    func getArticles() -> [ArticleData] {
        println("Returning list")
        return articles!
    }
    
    
    // MARK: NSCoding
    func encodeWithCoder(coder: NSCoder) {
        println("trying to encode articles, value: ")
        println(articles)
        coder.encodeObject(articles, forKey: "article")

    }
    
    required init(coder aDecoder: NSCoder) {
        var temp: AnyObject? = aDecoder.decodeObjectForKey("article")
        println("trying to load reading list in init...")
        if (temp != nil) {
            println("reading list loaded")
            //test = (temp  as! ReadingList).test
            articles = temp as! [ArticleData]
        } else {
            println("failed")
        }
    }
    
    func save() {
        println("trying to save")
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        println("data created, trying to write")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "readingList")
        println("success")
    }
    
    func load() -> Bool {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("readingList") as? NSData {
            let temp = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! ReadingList
            articles = temp.articles
            return true
        }
        return false
    }

}
