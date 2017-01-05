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
        print("Initalizing Reading List")
    }
    
    func addArticle(_ article: ArticleData) {
        print("Adding article")
        articles.append(article)
        
    }
    
    func removeArticle(_ index: Int) {
        print("Removing article")
        articles.remove(at: index)
    }
    
    func getArticles() -> [ArticleData] {
        print("Returning list")
        return articles!
    }
    
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        print("trying to encode articles, value: ")
        print(articles)
        coder.encode(articles, forKey: "article")

    }
    
    required init(coder aDecoder: NSCoder) {
        let temp: AnyObject? = aDecoder.decodeObject(forKey: "article") as AnyObject?
        print("trying to load reading list in init...")
        if (temp != nil) {
            print("reading list loaded")
            //test = (temp  as! ReadingList).test
            articles = temp as! [ArticleData]
        } else {
            print("failed")
        }
    }
    
    func save() {
        print("trying to save")
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        print("data created, trying to write")
        UserDefaults.standard.set(data, forKey: "readingList")
        print("success")
    }
    
    func load() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "readingList") as? Data {
            let temp = NSKeyedUnarchiver.unarchiveObject(with: data) as! ReadingList
            articles = temp.articles
            return true
        }
        return false
    }

}
