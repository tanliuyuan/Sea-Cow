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

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var share: UIBarButtonItem!
    
    var articleURL: String?
    var article: ArticleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.share.target = self
        self.share.action = #selector(ArticleViewController.shareIt)
        // Do any additional setup after loading the view.
        
        if(article != nil){
            self.navigationItem.title = article!.section.uppercased()
            let url = URL(string: article!.url)
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
            articleURL = article?.url
        }
        
    }
    

    
    @IBAction func back(_ sender: AnyObject) {
        performSegue(withIdentifier: "returnToReadingList", sender: self)
    }
    
    func shareIt() {

        let composer = TWTRComposer()
        
        composer.setText("Check out this awesome article!\n\n" + articleURL! + "\n\n#seaCow #articleTags? #whatever")
        composer.setImage(UIImage(named: "fabric"))
        
        composer.show { (result) -> Void in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }

    }

}
