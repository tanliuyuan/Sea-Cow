//
//  ReadingListViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/16/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class ReadingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTableView: UITableView!
    
    var readingList = NYTArticles()
    var selectedArticle: ArticleData?

    // A set of constant and variable strings for making up the URL for article searching using NYT's API
    let articleSearchBaseUrl = "http://api.nytimes.com/svc/mostpopular/v2"
    let articleSearchResourceType = "mostviewed" // mostemailed | mostshared | mostviewed
    let articleSearchSections = "all-sections"
    let articlesSearchNumOfDays = 1 // 1 | 7 | 30
    let articleSearchReturnFormat = ".json"
    let articleSearchAPIKey = "b772e34fc2a53d05fe60d6c63d0c0e4c:9:71573042"
    
    override func viewDidLoad() {
    
        
        super.viewDidLoad()
        
        var articleSearchUrl = articleSearchBaseUrl + "/" + articleSearchResourceType + "/" + articleSearchSections + "/" + "\(articlesSearchNumOfDays)" + articleSearchReturnFormat + "?" + "&API-Key=" + articleSearchAPIKey
        
        // load articles from the NYT API
        readingList.load(articleSearchUrl, loadCompletionHandler: {
            (nytArticles, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                println(unwrappedErrorString)
            } else {
             
                println(self.readingList.articles.count)
                self.myTableView.reloadData()
                
            }
        })
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.title?.text = readingList.articles[indexPath.row].title
        
        let url = NSURL(string: readingList.articles[indexPath.row].imageUrl)
        let data = NSData(contentsOfURL: url!)
        cell.backgroundImage.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArticle = readingList.articles[indexPath.row]
        performSegueWithIdentifier("showArticle", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! ArticleViewController
        destinationViewController.article = selectedArticle
    }
    
    @IBAction func back(sender: AnyObject) {
        performSegueWithIdentifier("returnToCards", sender: self)
    }
    
    @IBAction func returnToReadingList(segue: UIStoryboardSegue) {
        
    }

}
