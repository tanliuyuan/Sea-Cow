//
//  ArticleViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/16/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var share: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.share.target = self
        self.share.action = "shareIt"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func back(sender: AnyObject) {
        performSegueWithIdentifier("returnToReadingList", sender: self)
    }
    
    func shareIt() {
        print("hello share")
    }

}
