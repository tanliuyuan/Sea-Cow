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
    var label: UILabel
    
    required init(coder aDecoder: NSCoder) {
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: aDecoder)
        label = UILabel()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect){
        xFromCenter = 0.0
        yFromCenter = 0.0
        panGestureRecognizer = UIPanGestureRecognizer()
        originalPoint = CGPoint()
        overlayView = OverlayView(coder: NSCoder())
        label = UILabel()
        
        super.init(frame: frame)
        
        setupView()
        
        label = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        label.text = "There's nothing here"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.blackColor()
        
        self.backgroundColor = UIColor(red: 72/255, green: 145/255, blue: 206/255, alpha: 1)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
        
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(label)
        
        overlayView = OverlayView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            overlayView.alpha = 0
            self.addSubview(overlayView)
            
            self.superview
    }
    
    func setupView() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    // This function is called when the user's finger touches and pans over the screen
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        // .translationInView extracts the coordinate data from the swipe movement
        xFromCenter = gestureRecognizer.translationInView(self).x
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        // .state checks whether user is starting, panning, or letting go of the card
        switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            
        case UIGestureRecognizerState.Changed:
            var rotationStrength = min(CGFloat(xFromCenter) / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX)) as CGFloat
            var rotationAngle: CGFloat = (CGFloat(ROTATION_ANGLE) * rotationStrength)
            var scale = max((CGFloat(1) - CGFloat(rotationStrength) / CGFloat(SCALE_STRENGTH)), SCALE_MAX) as CGFloat
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            var scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
            
        case UIGestureRecognizerState.Possible:break
        case UIGestureRecognizerState.Cancelled:break
        case UIGestureRecognizerState.Failed:break
        }
    }
    
    // Checks to see if user's moving right or left and applies the corresponding overlay image
    func updateOverlay(distance: CGFloat) {
        
        // If card is being dragged to the right
        if distance > 0 {
            overlayView.mode = OverlayViewMode.OverlayViewRight
        } else { // If card is being dragged to the left
            overlayView.mode = OverlayViewMode.OverlayViewLeft
        }
        
        overlayView.alpha = min(CGFloat(distance)/100, 0.4)
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
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    // Called when user swipes right
    func rightAction(background: SwipeCardsViewBackground) {
        var finishPoint: CGPoint = CGPointMake(500, 2 * yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
            }
        background.swipeRight()
        println("YES")
    }
    
    // Called when user swipes left
    func leftAction(background: SwipeCardsViewBackground) {
        var finishPoint: CGPoint = CGPointMake(-500, 2 * yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = finishPoint
            }) { (complete) -> Void in
                self.removeFromSuperview()
        }
        background.swipeLeft()
        println("NO")
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
