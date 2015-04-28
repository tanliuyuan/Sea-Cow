//
//  OverlayView.swift
//  seaCow
//
//  Created by Liuyuan Tan on 4/20/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import Foundation
import UIKit

enum OverlayViewMode : Int {
    case OverlayViewLeft
    case OverlayViewRight
}

class OverlayView: UIView {
    
    var mode: OverlayViewMode
    var imageView: UIImageView
    
    override init(frame:CGRect) {
        mode = OverlayViewMode.OverlayViewRight
        imageView = UIImageView()
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(image: UIImage(named: "noButton"))
        self.addSubview(imageView)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        //mode = OverlayViewMode.OverlayViewRight // tmp init
        //imageView = UIImageView()
        self.init()
    }
    
    func setMode(mode: OverlayViewMode) {
        if mode == OverlayViewMode.OverlayViewLeft {
            imageView.image = UIImage(named: "noButton")
        } else {
            imageView.image = UIImage(named: "yesButton")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(50, 50, 100, 100)
        imageView.backgroundColor = UIColor(red: 72/255, green: 145/255, blue: 206/255, alpha: 1)
    }
    
}
