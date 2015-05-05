//
//  CardViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/14/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var readingListButton: UIBarButtonItem!
    var allArticles: [ArticleData]?
    var swipeCardsViewBackground: SwipeCardsViewBackground?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subViewFrame: CGRect = CGRectMake(0, self.navBar.frame.height+UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-self.navBar.frame.height)
        /*var subView: UIView = UIView(frame: subViewFrame)
        subView.alpha = 1
        self.view.addSubview(subView)*/
        
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("preparing for segue")
        
        let destViewController = segue.destinationViewController as! ReadingListViewController
        
        destViewController.allArticles = swipeCardsViewBackground!.toReadingList
    }

       @IBAction func returnToCards(segue: UIStoryboardSegue) {
        
    }

}
