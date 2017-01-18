import UIKit
import UserNotifications

class CardViewController: UIViewController {
    
    var allArticles: [ArticleData]?
    var swipeCardsViewBackground: SwipeCardsViewBackground?
    var testArticles: ReadingList?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scheduleLocalNotifications()
        
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
            destViewController.listArticles = swipeCardsViewBackground!.testArticles
        }
        
    }

    @IBAction func returnToCards(_ segue: UIStoryboardSegue) {
        
    }
    
    func scheduleLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Sea Cow", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hey! Sea Cow's got you some news!",
                                                                arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Configure the trigger for 8AM.
        var dateInfo = DateComponents()
        dateInfo.hour = 8
        dateInfo.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        // Create the request object.
        let request = UNNotificationRequest(identifier: "SeaCow", content: content, trigger: trigger)
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    
    func loadCards() {
        let subViewFrame: CGRect = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.height-UIApplication.shared.statusBarFrame.height-self.navigationController!.navigationBar.frame.size.height)
        swipeCardsViewBackground = SwipeCardsViewBackground(frame: subViewFrame)
        self.view.addSubview(swipeCardsViewBackground!)
    }
    
}
