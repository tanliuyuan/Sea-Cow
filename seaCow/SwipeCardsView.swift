//
//  SwipeCardsView.swift
//  Seacow
//
//  Created by Liuyuan Tan on 4/16/15.
//  Copyright (c) 2015 Liuyuan Tan. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN = 50 // Distance from center when action is triggered. Higher = swipe further for the action to be called
let SCALE_STRENGTH = 4 // How quick the card shrinks. Higher = slower shrinkng
let SCALE_MAX: CGFloat = 0.93 // How much the card can shrink. Higher = shrinks less
let ROTATION_STRENGTH = 320 // Strength of rotation. Higher = weaker rotation
let ROTATION_MAX = 1 /// Maximum rotation allowed in radians. Higher = longer rotation time
let ROTATION_ANGLE = M_PI/8 // Higher = larger rotation angle

class SwipeCardsView: UIView {
    
    var xFromCenter: CGFloat
    var yFromCenter: CGFloat
    var panGestureRecognizer: UIPanGestureRecognizer
    var originalPoint: CGPoint
    var overlayView: OverlayView
    var backgroundView: UIImageView
    var gradientView: UIImageView
    var label: UILabel
    var articleData: ArticleData
    
    required init(coder aDecoder: NSCoder) {
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: aDecoder)
        backgroundView = UIImageView()
        gradientView = UIImageView()
        label = UILabel()
        articleData = ArticleData()
        
        super.init(coder: aDecoder)
        
        let gradientImage = UIImage(named: "gradient.png")
        gradientView = UIImageView(image: gradientImage)
        gradientView.contentMode = UIViewContentMode.scaleAspectFill
        
        label.text = "No Data"
        
    }
    
    override init(frame: CGRect){
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: NSCoder())
        backgroundView = UIImageView()
        gradientView = UIImageView()
        label = UILabel()
        articleData = ArticleData()
        
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: self.frame.size.width * 0.05, y: self.frame.size.height * 0.6, width: self.frame.size.width * 0.85, height: self.frame.size.height * 0.4))
        label.textAlignment = NSTextAlignment.natural
        label.textColor = UIColor.white
        label.font = UIFont(name: "Gotham Bold", size: 24)
        label.numberOfLines = 0
        
        let backgroundImage = UIImage(named: "cardbackground.png")
        backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height))
        backgroundView.image = backgroundImage
        
        let gradientImage = UIImage(named: "gradient.png")
        gradientView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height))
        gradientView.image = gradientImage
        
        setupView()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeCardsView.beingDragged(_:)))
        
        self.addGestureRecognizer(panGestureRecognizer)
        
        overlayView = OverlayView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        overlayView.alpha = 0
        self.addSubview(overlayView)
            
        self.superview
    }
    
    func setupView() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
        self.addSubview(backgroundView)
        backgroundView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(gradientView)
        gradientView.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(label)
        
        self.backgroundView.layer.cornerRadius = 10
        self.backgroundView.layer.masksToBounds = true
        self.gradientView.layer.cornerRadius = 10
        self.gradientView.layer.masksToBounds = true
    }
    
    // This function is called when the user's finger touches and pans over the screen
    func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        // .translationInView extracts the coordinate data from the swipe movement
        xFromCenter = gestureRecognizer.translation(in: self).x
        yFromCenter = gestureRecognizer.translation(in: self).y
        
        // .state checks whether user is starting, panning, or letting go of the card
        switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerState.began:
            self.originalPoint = self.center
            
        case UIGestureRecognizerState.changed:
            let rotationStrength = min(CGFloat(xFromCenter) / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX)) as CGFloat
            let rotationAngle: CGFloat = (CGFloat(ROTATION_ANGLE) * rotationStrength)
            let scale = max((CGFloat(1) - CGFloat(rotationStrength) / CGFloat(SCALE_STRENGTH)), SCALE_MAX) as CGFloat
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            let transform: CGAffineTransform = CGAffineTransform(rotationAngle: rotationAngle)
            let scaleTransform: CGAffineTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
            
        case UIGestureRecognizerState.possible:break
        case UIGestureRecognizerState.cancelled:break
        case UIGestureRecognizerState.failed:break
        }
    }
    
    // Checks to see if user's moving right or left and applies the corresponding overlay image
    func updateOverlay(_ distance: CGFloat) {
        // If card is being dragged to the right
        if distance > 0 {
            overlayView.setMode(OverlayViewMode.overlayViewRight)
        } else if distance < 0 { // If card is being dragged to the left
            overlayView.setMode(OverlayViewMode.overlayViewLeft)
        }
        
        overlayView.alpha = min(CGFloat(abs(distance))/100, 0.4)
    }
    
    // Called when the card is let go
    func afterSwipeAction() {
        if xFromCenter > CGFloat(ACTION_MARGIN) {
            self.rightAction(self.superview as! SwipeCardsViewBackground)
        }
        else if xFromCenter < CGFloat(-ACTION_MARGIN) {
            self.leftAction(self.superview as! SwipeCardsViewBackground)
        }
        else {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    // Called when user swipes right
    func rightAction(_ background: SwipeCardsViewBackground) {
        var finishPoint: CGPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.center = finishPoint
            }, completion: { (complete) -> Void in
                self.removeFromSuperview()
            }) 
        background.swipeRight()
        print("YES")
    }
    
    // Called when user swipes left
    func leftAction(_ background: SwipeCardsViewBackground) {
        var finishPoint: CGPoint = CGPoint(x: -500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.center = finishPoint
            }, completion: { (complete) -> Void in
                self.removeFromSuperview()
        }) 
        background.swipeLeft()
        print("NO")
    }
    /*
    // Called when user clicks "yes" button
    func yesClickAction() {
        var finishPoint: CGPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        println("YES")
    }
    
    // Called when user clicks "no" button
    func noClickAction() {
        var finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        println("NO")
    }
    */
}
