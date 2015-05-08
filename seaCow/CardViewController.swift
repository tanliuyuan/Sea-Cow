//
//  CardViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/14/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var readingListButton: UIBarButtonItem!
    var allArticles: [ArticleData]?
    var swipeCardsViewBackground: SwipeCardsViewBackground?
    var testArticles: ReadingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCards()
        
    }
    
    @IBAction func gotoReadingList(sender: AnyObject) {
        println("Going to reading list")
        performSegueWithIdentifier("CowToList", sender: CardViewController())
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("preparing for segue")
        let comp: String? = "CowToList"
        if(segue.identifier == comp) {
            let destViewController = segue.destinationViewController as! ReadingListViewController
            
           // destViewController.allArticles = swipeCardsViewBackground!.toReadingList
            destViewController.testArticles = swipeCardsViewBackground!.testArticles
        }
        
    }

    @IBAction func returnToCards(segue: UIStoryboardSegue) {
        
    }
    
    func loadCards() {
        let subViewFrame: CGRect = CGRectMake(0, self.navBar.frame.height+UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-self.navBar.frame.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)
    }

}
