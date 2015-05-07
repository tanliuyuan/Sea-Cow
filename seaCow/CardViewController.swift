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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subViewFrame: CGRect = CGRectMake(0, self.navBar.frame.height+UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-self.navBar.frame.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)

    }
    
    
    @IBAction func test(sender: AnyObject) {
        println("hello")
        performSegueWithIdentifier("CowToList", sender: CardViewController())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("preparing for segue")
        let comp: String? = "CowToList"
        if(segue.identifier == comp) {
            let destViewController = segue.destinationViewController as! ReadingListViewController
            
            destViewController.allArticles = swipeCardsViewBackground!.toReadingList
        }
        
    }

       @IBAction func returnToCards(segue: UIStoryboardSegue) {
        
    }

}
