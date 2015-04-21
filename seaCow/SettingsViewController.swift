//
//  SettingsViewController.swift
//  seaCow
//
//  Created by Scott Gavin on 4/16/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit
import TwitterKit


class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            // play with Twitter session
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
