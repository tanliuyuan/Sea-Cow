//
//  ReadingListViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/16/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class ReadingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTableView: UITableView!
    
    var readingList = NYTArticles()
    var allArticles: [ArticleData]?
    var selectedArticle: ArticleData?

    // A set of constant and variable strings for making up the URL for article searching using NYT's API
    let articleSearchBaseUrl = "http://api.nytimes.com/svc/mostpopular/v2"
    let articleSearchResourceType = "mostviewed" // mostemailed | mostshared | mostviewed
    let articleSearchSections = "all-sections"
    let articlesSearchNumOfDays = 1 // 1 | 7 | 30
    let articleSearchReturnFormat = ".json"
    let articleSearchAPIKey = "b772e34fc2a53d05fe60d6c63d0c0e4c:9:71573042"
    var testArticles: ReadingList?
    
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
        allArticles = testArticles?.getArticles()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allArticles!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        if(allArticles!.count > 0) {
            
        
            //cell.title?.text = readingList.articles[indexPath.row].title
            cell.title?.text = allArticles![indexPath.row].title
            //let url = NSURL(string: readingList.articles[indexPath.row].imageUrl)
            let url = NSURL(string: allArticles![indexPath.row].imageUrl)
            let data = NSData(contentsOfURL: url!)
            
            
            
            cell.backgroundImage.image = UIImage(data: data!)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArticle = allArticles![indexPath.row]
        performSegueWithIdentifier("showArticle", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal , title: "Share", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            
            let composer = TWTRComposer()
            
            composer.setText("Check out this awesome article!\n\n" + self.allArticles![indexPath.row].url + "\n\n#seaCow #articleTags? #whatever")
            composer.setImage(UIImage(named: "fabric"))
            
            composer.showWithCompletion { (result) -> Void in
                if (result == TWTRComposerResult.Cancelled) {
                    println("Tweet composition cancelled")
                }
                else {
                    println("Sending tweet!")
                }
            }
            
            self.myTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            return
        })
        
        shareAction.backgroundColor = UIColor.blueColor()
       
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default , title: "Delete", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            
            self.allArticles?.removeAtIndex(indexPath.row)
            self.testArticles?.removeArticle(indexPath.row)
            self.myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.testArticles!.save()
            return
        })
        
        return [deleteAction, shareAction]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showArticle"){
        let destinationViewController = segue.destinationViewController as! ArticleViewController
        destinationViewController.article = selectedArticle
        }
        
    }
    
    @IBAction func back(sender: AnyObject) {
        performSegueWithIdentifier("returnToCards", sender: self)
    }
    
    @IBAction func returnToReadingList(segue: UIStoryboardSegue) {
        
    }
    
    

}
