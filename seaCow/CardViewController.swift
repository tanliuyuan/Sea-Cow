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
        
        navBar.barTintColor = UIColor.whiteColor()
        settingsButton.image = UIImage(named: "settingsno.png")
        settingsButton.tintColor = UIColor.grayColor()
        //readingListButton.image = UIImage(named: <#String#>)

        scheduleLocalNotifications()
        
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
    
    func scheduleLocalNotifications() {
        let dateString1 = "2000-01-01 8:00"
        let dateString2 = "2000-01-01 18:00"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = NSTimeZone.systemTimeZone()
        let fireDate1 = formatter.dateFromString(dateString1)
        let fireDate2 = formatter.dateFromString(dateString2)
        
        var localNotification = UILocalNotification()
        localNotification.alertAction = "Sea Cow"
        localNotification.alertBody = "Hey! Sea Cow's got you some news!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        // set first notification time
        localNotification.fireDate = fireDate1
        // repeat notification daily
        localNotification.repeatInterval = NSCalendarUnit.CalendarUnitDay
        // schedule first notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        // set second notification time
        localNotification.fireDate = fireDate2
        // schedule second notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func loadCards() {
        let subViewFrame: CGRect = CGRectMake(0, self.navBar.frame.height+UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-UIApplication.sharedApplication().statusBarFrame.height-self.navBar.frame.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)
    }

}
