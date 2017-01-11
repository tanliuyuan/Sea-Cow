import UIKit

class CardViewController: UIViewController {
    
    var allArticles: [ArticleData]?
    var swipeCardsViewBackground: SwipeCardsViewBackground?
    var testArticles: ReadingList?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scheduleLocalNotifications()
        
        //create the time and repeat every 12 hours
        let test: Timer = Timer(fireAt: checkWhichDate(), interval: 5, target: self, selector: #selector(CardViewController.loadCards), userInfo: nil, repeats: true)
        RunLoop.current.add(test, forMode: RunLoopMode.commonModes)
        print("Ready to load cards")
        loadCards()
        
    }
    
    @IBAction func gotoReadingList(_ sender: AnyObject) {
        print("Going to reading list")
        performSegue(withIdentifier: "CowToList", sender: CardViewController())
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        let comp: String? = "CowToList"
        if(segue.identifier == comp) {
            let destViewController = segue.destination as! ReadingListViewController
            
           // destViewController.allArticles = swipeCardsViewBackground!.toReadingList
            destViewController.testArticles = swipeCardsViewBackground!.testArticles
        }
        
    }

    @IBAction func returnToCards(_ segue: UIStoryboardSegue) {
        
    }
    
    func scheduleLocalNotifications() {
        let dateString1 = "2000-01-01 8:00"
        let dateString2 = "2000-01-01 20:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let fireDate1 = formatter.date(from: dateString1)
        let fireDate2 = formatter.date(from: dateString2)
        
        let localNotification = UILocalNotification()
        localNotification.alertAction = "Sea Cow"
        localNotification.alertBody = "Hey! Sea Cow's got you some news!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        // set first notification time
        localNotification.fireDate = fireDate1
        // repeat notification daily
        localNotification.repeatInterval = NSCalendar.Unit.day
        // schedule first notification
        UIApplication.shared.scheduleLocalNotification(localNotification)
        // set second notification time
        localNotification.fireDate = fireDate2
        // schedule second notification
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    
    
    func loadCards() {
        let subViewFrame: CGRect = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.height-UIApplication.shared.statusBarFrame.height-self.navigationController!.navigationBar.frame.size.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)
    }
    
    func test() {
        print("test")
    }
    
    func checkWhichDate() -> Date{
        
        var dateString1 = "2000-01-01 8:00"
        var dateString2 = "2015-05-12 20:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .day, .year, .month], from: date)
        let year = components.year! as NSNumber
        let month = components.month! as NSNumber
        let day = components.day! as NSNumber
        let hour = components.hour
        let hour1 = 8 as NSNumber
        let hour2 = 20 as NSNumber
        let day1 = (day as Int + 1) as NSNumber
        
        if(hour! > 8) {
            dateString1 = year.stringValue + "-" + month.stringValue + "-" + day1.stringValue + " " + hour1.stringValue + ":00"
        } else {
            dateString1 = year.stringValue + "-" + month.stringValue + "-" + day.stringValue + " " + hour1.stringValue + ":00"
        }
        dateString2 = year.stringValue + "-" + month.stringValue + "-" + day.stringValue + " " + hour2.stringValue + ":00"
        
        print(dateString1)
        print(dateString2)
        
        let fireDate1 = formatter.date(from: dateString1)
        let fireDate2 = formatter.date(from: dateString2)
        if(hour! > 8 && hour! < 20) {
            //return 20:00
            return fireDate2!
            
        } else {
            //return 8:00
            return fireDate1!
        }
    }



}
