//
//  ReadingList.swift
//  seaCow
//
//  Created by Scott Gavin on 5/7/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class ReadingList: NSObject , NSCoding {
    private var articles: [ArticleData]! = []
    
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
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.articles = decoder.decodeObjectForKey("articles") as! [ArticleData]?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.articles, forKey: "articles")

    }
}
