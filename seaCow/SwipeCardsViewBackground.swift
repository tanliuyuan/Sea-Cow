//
//  SwipeCardsViewBackground.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/20/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import Foundation
import UIKit

// A set of constant and variable strings for making up the URL for article searching using NYT's API
let articleSearchBaseUrl = "http://api.nytimes.com/svc/mostpopular/v2"
let articleSearchResourceType = "mostviewed" // mostemailed | mostshared | mostviewed
let articleSearchSections = "all-sections"
let articlesSearchNumOfDays = 1 // 1 | 7 | 30
let articleSearchReturnFormat = ".json"
let articleSearchAPIKey = "b772e34fc2a53d05fe60d6c63d0c0e4c:9:71573042"

class SwipeCardsViewBackground: UIView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let MAX_CARD_NUM = 5 // maximum number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var loaded: Int = 0 // number of cards loaded
    var deck = [SwipeCardsView]() // array of loaded cards
    
    var settingsButton: UIButton
    var readingListButton: UIButton
    /*var yesButton: UIButton
    var noButton: UIButton*/
    
    var exampleCardLabels: AnyObject = [] // temp
    var allCards = [SwipeCardsView]() // temp
    
    var nytArticles = NYTArticles()
    var articleRequest: NSURLRequest?
    var selectedArticle: ArticleData?
    
    
    override init(frame: CGRect) {
        
        settingsButton = UIButton()
        readingListButton = UIButton()
        /*yesButton = UIButton()
        noButton = UIButton()*/
        super.init(frame:frame)
        self.setupView()
        
        // Make up search url
        var articleSearchUrl = articleSearchBaseUrl + "/" + articleSearchResourceType + "/" + articleSearchSections + "/" + "\(articlesSearchNumOfDays)" + articleSearchReturnFormat + "?" + "&API-Key=" + articleSearchAPIKey
        
        // load articles from the NYT API
        nytArticles.load(articleSearchUrl, loadCompletionHandler: {
            (nytArticles, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                println(unwrappedErrorString)
            } else {
                for article in nytArticles.articles {
                    println(article);
                }
                self.loaded = 0
                self.loadCards()
            }
        })
        
        //exampleCardLabels = ["first news", "second news", "third news", "fourth news", "fifth news"]
        
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        settingsButton = UIButton(frame: CGRectMake(17, 34, 22, 15))
        settingsButton.setImage(UIImage(named: "settingsButton"), forState: UIControlState.Normal)
        
        readingListButton = UIButton(frame: CGRectMake(284, 34, 18, 18))
        readingListButton.setImage(UIImage(named: "readingListButton"), forState: UIControlState.Normal)
        
        /*yesButton = UIButton(frame: CGRectMake(60, 485, 59, 59))
        yesButton.setImage(UIImage(named: "yesButton"), forState: UIControlState.Normal)
        yesButton.addTarget(self, action: "swipeRight", forControlEvents: UIControlEvents.TouchUpInside)
        
        noButton = UIButton(frame: CGRectMake(200, 485, 59, 59))
        noButton.setImage(UIImage(named: "noButton"), forState: UIControlState.Normal)
        noButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)*/
        
        self.addSubview(settingsButton)
        self.addSubview(readingListButton)
        /*self.addSubview(yesButton)
        self.addSubview(noButton)*/
        
    }
    
    func loadCards() {
        
        if exampleCardLabels.count > 0 {
            // make sure max card load is smaller than actual deck size
            var numLoadedCardsCap = exampleCardLabels.count > MAX_CARD_NUM ? MAX_CARD_NUM : exampleCardLabels.count
            
            // loop through the exampleCardsLabels array to create a card for each label. This should be customerized by removing "exampleCardLabels" with another array of data
            for var i = 0 ; i < exampleCardLabels.count; i++ {
                var newCard: SwipeCardsView = self.createSwipeCardsViewWithDataAtIndex(i)
                allCards.append(newCard)
                
                if i < numLoadedCardsCap {
                    // add some extra cards to be loaded
                    deck.append(newCard)
                }
            }
        }
        
        // display extra loaded cards
        for var i = 0; i < deck.count; i++ {
            if i > 0 {
                self.insertSubview(deck[i] as UIView, belowSubview: deck[i-1] as UIView)
            } else {
                self.addSubview(deck[i] as UIView)
            }
            loaded++
        }
    }
    
    func cardSwipedAway(card: UIView) {
        deck.removeAtIndex(0)
        
        // if all cards haven't been gone through, load another card into the deck
        if loaded < allCards.count {
            deck.append(allCards[loaded])
            loaded++
            self.insertSubview(deck[MAX_CARD_NUM-1] as UIView, belowSubview: deck[MAX_CARD_NUM-2] as UIView)
        }
    }
    
    func swipeRight() {
        var cardView: SwipeCardsView = deck.first!
        cardView.overlayView.mode = OverlayViewMode.OverlayViewRight
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            cardView.overlayView.alpha = 1
        })
        // cardView.yesClickAction
    }
    
    func swipeLeft() {
        var cardView: SwipeCardsView = deck.first!
        cardView.overlayView.mode = OverlayViewMode.OverlayViewLeft
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            cardView.overlayView.alpha = 1
        })
        // cardView.noClickAction
    }
    
    func createSwipeCardsViewWithDataAtIndex(index: Int) -> SwipeCardsView {
        var swipeCardsView: SwipeCardsView = SwipeCardsView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH) / 2, (self.frame.size.height - CARD_HEIGHT) / 2, CARD_WIDTH, CARD_HEIGHT))
        swipeCardsView.label.text = exampleCardLabels.objectAtIndex(index) as? String
        return swipeCardsView
    }
}
