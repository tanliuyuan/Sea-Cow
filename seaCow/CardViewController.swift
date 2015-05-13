//
//  CardViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/14/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    var allArticles: [ArticleData]?
    var swipeCardsViewBackground: SwipeCardsViewBackground?
    var testArticles: ReadingList?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scheduleLocalNotifications()
        
        //create the time and repeat every 12 hours
        let test: NSTimer = NSTimer(fireDate: checkWhichDate(), interval: 5, target: self, selector: "loadCards", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(test, forMode: NSRunLoopCommonModes)
        
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
        let dateString2 = "2000-01-01 20:00"
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
        let subViewFrame: CGRect = CGRectMake(0, self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-UIApplication.sharedApplication().statusBarFrame.height-self.navigationController!.navigationBar.frame.size.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)
    }
    
    func test() {
        println("test")
    }
    
    func checkWhichDate() -> NSDate{
        
        var dateString1 = "2000-01-01 8:00"
        var dateString2 = "2015-05-12 20:00"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = NSTimeZone.systemTimeZone()
        
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let year = components.year as NSNumber
        let month = components.month as NSNumber
        let day = components.day as NSNumber
        let hour = components.hour
        let hour1 = 8 as NSNumber
        let hour2 = 20 as NSNumber
        let day1 = (day as Int + 1) as NSNumber
        
        if(hour > 8) {
            dateString1 = year.stringValue + "-" + month.stringValue + "-" + day1.stringValue + " " + hour1.stringValue + ":00"
        } else {
            dateString1 = year.stringValue + "-" + month.stringValue + "-" + day.stringValue + " " + hour1.stringValue + ":00"
        }
        dateString2 = year.stringValue + "-" + month.stringValue + "-" + day.stringValue + " " + hour2.stringValue + ":00"
        
        println(dateString1)
        println(dateString2)
        
        let fireDate1 = formatter.dateFromString(dateString1)
        let fireDate2 = formatter.dateFromString(dateString2)
        if(hour > 8 && hour < 20) {
            //return 20:00
            return fireDate2!
            
        } else {
            //return 8:00
            return fireDate1!
        }
    }



}
