//
//  CardViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/14/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeCardsViewBackground = SwipeCardsViewBackground(frame: self.view.frame)
        self.view.addSubview(swipeCardsViewBackground)
        
    }

       @IBAction func returnToCards(segue: UIStoryboardSegue) {
        
    }

}
