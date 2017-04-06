//
//  ZFRippleButton.swift
//  ZFRippleButtonDemo
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//

import UIKit
import QuartzCore

class ZFRippleButton: UIButton {
    
    @IBInspectable var ripplePercent: CGFloat = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    @IBInspectable var rippleOverBounds: Bool = false {
        didSet {
            if rippleOverBounds {
                rippleBackgroundView.layer.mask = nil
            } else {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).CGPath
                rippleBackgroundView.layer.mask = maskLayer
            }
        }
    }
    @IBInspectable var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    @IBInspectable var rippleBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 1) {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    @IBInspectable var shadowRippleRadius: Float = 1
    @IBInspectable var shadowRippleEnable: Bool = true
    @IBInspectable var trackTouchLocation: Bool = false
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    var tempShadowRadius: CGFloat = 0
    var tempShadowOpacity: CGFloat = 0
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.alpha = 0
        
        rippleOverBounds = false
        
        layer.addSublayer(rippleBackgroundView.layer)
        rippleBackgroundView.layer.addSublayer(rippleView.layer)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
    }
    
    func setupRippleView() {
        let size: CGFloat = CGRectGetWidth(bounds) * ripplePercent
        let x: CGFloat = (CGRectGetWidth(bounds)/2) - (size/2)
        let y: CGFloat = (CGRectGetHeight(bounds)/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRectMake(x, y, size, size)
        rippleView.layer.cornerRadius = corner
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent!) -> Bool {
        if trackTouchLocation {
            rippleView.center = touch.locationInView(self)
        }
        
        UIView.animateWithDuration(0.1, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: nil)
        
        rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
            self.rippleView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = CGFloat( layer.shadowOpacity)
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.removedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.addAnimation(groupAnim, forKey:"shadow")
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override func endTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        UIView.animateWithDuration(0.1, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: {(success: Bool) -> () in
                UIView.animateWithDuration(0.6 , animations: {
                    self.rippleBackgroundView.alpha = 0
                    }, completion: {(success: Bool) -> () in
                        
                })
        })
        
        UIView.animateWithDuration(0.7, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut] , animations: {
            self.rippleView.transform = CGAffineTransformIdentity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = self.tempShadowRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = self.tempShadowOpacity
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.removedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            self.layer.addAnimation(groupAnim, forKey:"shadowBack")
            }, completion: nil)
    }
    
}