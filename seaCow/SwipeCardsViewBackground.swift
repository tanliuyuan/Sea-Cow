import Foundation
import UIKit

// A set of constant and variable strings for making up the URL for searching using NYT's Top Stories API
let topStoriesBaseUrl = "https://api.nytimes.com/svc/topstories/v2"
let topStoriesSection = "home"  //home | opinion | world | national | politics | upshot | nyregion | business | technology |science | health | sports | arts | books | movies | theater | sundayreview | fashion | tmagazine | food | travel | magazine | realestate | automobiles | obituaries | insider
let topStoriesReturnFormat = ".json" // .json | .jsonp
let topStoriesAPIKey = "ebe481192b8e46f1a6d27d20649e572c"

class SwipeCardsViewBackground: UIView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let MAX_CARD_NUM: Int = 2 // maximum number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT: CGFloat = UIScreen.main.bounds.size.height * 0.75
    let CARD_WIDTH: CGFloat = UIScreen.main.bounds.size.width * 0.9
    
    var loaded: Int = 0 // number of cards loaded
    var deck = [SwipeCardsView]() // array of loaded cards
    
    /*var settingsButton: UIButton
    var readingListButton: UIButton
    var yesButton: UIButton
    var noButton: UIButton*/
    
    var allCards = [SwipeCardsView]() // array of all cards
    
    var nytArticles = NYTArticles()
    var articleRequest: URLRequest?
    var selectedArticle: ArticleData?
    var toReadingList: [ArticleData] = []
    var done = false
    var testArticles: ReadingList = ReadingList()
    
    override init(frame: CGRect) {
        
        /*var settingsButton: UIButton
        var readingListButton: UIButton
        var yesButton: UIButton
        var noButton: UIButton*/
        
        super.init(frame:frame)
        
        if(testArticles.load() == true) {
            print("Reading List successfully loaded")
        }
        
        // prepare a loading indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: self.frame.width * 19/40, y: (self.frame.height - self.frame.width / 20) / 2, width: self.frame.width / 20, height: self.frame.width / 20)
        self.addSubview(indicator)
        indicator.bringSubview(toFront: self)
        
        // start loading indicator before loading cards
        indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //self.setupView()
        
        var stringTitles: [String] = []
        // Make up search url
        let topStoriesUrl = topStoriesBaseUrl + "/" + topStoriesSection + topStoriesReturnFormat + "?" + "&api-key=" + topStoriesAPIKey
        
        // load articles from the NYT API
        nytArticles.load(topStoriesUrl, loadCompletionHandler: {
            (nytArticles, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
            } else {
                for article in nytArticles.articles {
                    let card = SwipeCardsView()
                    let labelTextStyle = NSMutableParagraphStyle()
                    labelTextStyle.lineSpacing = 10
                    labelTextStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
                    let attributes = [NSParagraphStyleAttributeName : labelTextStyle]
                    card.label.attributedText = NSAttributedString(string: article.title, attributes:attributes)
                    card.articleData = article
                    if let imageUrl = URL(string: card.articleData.imageUrl) {
                        if let imageData = try? Data(contentsOf: imageUrl){
                            card.backgroundView = UIImageView(image: UIImage(data: imageData)!)
                        }
                    }
                    self.allCards.append(card)
                }
                print("Total number of cards:\(self.allCards.count)")
                self.loaded = 0
                self.loadCards()
                
                // stop loading indicator after cards are loaded
                indicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        
    }
    
    /*func setupView() {
        let backgroundImage = UIImage(named: "background")
        let backgroundImageView = UIImageView(image: backgroundImage)
        self.addSubview(backgroundImageView)
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
    }*/
    
    func loadCards() {
        
        if allCards.count > 0 {
            // make sure max card load is smaller than actual deck size
            let numLoadedCardsCap = allCards.count > MAX_CARD_NUM ? MAX_CARD_NUM : allCards.count
            
            // loop through the exampleCardsLabels array to create a card for each label. This should be customerized by removing "exampleCardLabels" with another array of data
            for i in 0  ..< allCards.count {
                let newCard: SwipeCardsView = self.createSwipeCardsViewWithDataAtIndex(i)
                
                if i < numLoadedCardsCap {
                    // add some extra cards to be loaded
                    deck.append(newCard)
                }
            }
        }
        
        // display extra loaded cards
        for i in 0 ..< deck.count {
            if i > 0 {
                self.insertSubview(deck[i] as UIView, belowSubview: deck[i-1] as UIView)
            } else {
                self.addSubview(deck[i] as UIView)
            }
            loaded += 1
        }
        print("Number of cards loaded: \(loaded)")
        
    }
    var swiped: Int = 0
    func cardSwipedAway(_ card: UIView, direction: String) {
        let history: History = History()
        history.load()
        swiped += 1
        let article: ArticleData = deck[0].articleData
        deck.remove(at: 0)
        print("Card swiped away")
        if(history.checkIfExists(article.title)) == false {
            history.addArticle(article)
            history.save()
        }
        if(direction == "right") {
            print("Saving to reading list array")
            toReadingList.append(article)
            testArticles.addArticle(article)
            testArticles.save()
        }
        // if all cards haven't been gone through, load another card into the deck
        if loaded < allCards.count {
            let newCard: SwipeCardsView = createSwipeCardsViewWithDataAtIndex(loaded)
            deck.append(newCard)
            //deck.append(allCards[loaded])
            loaded += 1
            self.insertSubview(deck[MAX_CARD_NUM-1] as UIView, belowSubview: deck[MAX_CARD_NUM-2] as UIView)
        }
        if(swiped == allCards.count) {
            print("Last card has been swiped")
            print(toReadingList.count)
            //try to segue to the reading list here.
            done = true
            self.window?.rootViewController?.childViewControllers[0].performSegue(withIdentifier: "CowToList", sender: self)
        }
    }
    
    func swipeRight() {
        let cardView: SwipeCardsView = deck.first!
        cardView.overlayView.mode = OverlayViewMode.overlayViewRight
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            cardView.overlayView.alpha = 1
        })
        cardSwipedAway(cardView, direction: "right")
    }
    
    func swipeLeft() {
        let cardView: SwipeCardsView = deck.first!
        cardView.overlayView.mode = OverlayViewMode.overlayViewLeft
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            cardView.overlayView.alpha = 1
        })
        cardSwipedAway(cardView, direction: "left")
    }
    
    func createSwipeCardsViewWithDataAtIndex(_ index: Int) -> SwipeCardsView {
        let swipeCardsView: SwipeCardsView = SwipeCardsView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH) / 2, y: (self.frame.size.height - CARD_HEIGHT) / 2.5, width: CARD_WIDTH, height: CARD_HEIGHT))
        swipeCardsView.articleData = allCards[index].articleData
        swipeCardsView.backgroundView.image = allCards[index].backgroundView.image
        swipeCardsView.label.attributedText = allCards[index].label.attributedText
        return swipeCardsView
    }
    
}
