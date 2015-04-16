//
//  SwipeCardsView.swift
//  Seacow
//
//  Created by Liuyuan Tan on 4/16/15.
//  Copyright (c) 2015 Seacow. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN = 120 // Distance from center where the action applies. Higher = swipe further for the action to be called
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
    
    required init(coder aDecoder:NSCoder) {
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
        
        label = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        label.text = "There's nothing here"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.blackColor()
        
        self.backgroundColor = UIColor(red: 72/255, green: 145/255, blue: 206/255, alpha: 1)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
        
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(label)
        
        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100)
            overlayView.alpha = 0
            self.addSubview(overlayView)
            
            self.superview
    }
    
    func setupView() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
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
            
        }
    }
}
