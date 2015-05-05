//
//  ArticleViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/16/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class ArticleViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var share: UIBarButtonItem!
    
    var articleURL: String? = "google.com"
    var article: ArticleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.share.target = self
        self.share.action = "shareIt"
        // Do any additional setup after loading the view.
        
        if(article != nil){
            navBar.title = article!.section
            let url = NSURL(string: article!.url)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
        
    }
    

    
    @IBAction func back(sender: AnyObject) {
        performSegueWithIdentifier("returnToReadingList", sender: self)
    }
    
    func shareIt() {

        let composer = TWTRComposer()
        
        composer.setText("Check out this awesome article!\n\n" + articleURL! + "\n\n#seaCow #articleTags? #whatever")
        composer.setImage(UIImage(named: "fabric"))
        
        composer.showWithCompletion { (result) -> Void in
            if (result == TWTRComposerResult.Cancelled) {
                println("Tweet composition cancelled")
            }
            else {
                println("Sending tweet!")
            }
        }

    }

}
