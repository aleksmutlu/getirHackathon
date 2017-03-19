//
//  Shakable.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 19/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

fileprivate let kButtonAnimation = "buttonAnimation"

// MARK: - Shakable
protocol Shakable {
    func shake()
    var animationKey: String { get }
}

// MARK: - TextField Animation
extension UITextField: Shakable {
    
    var animationKey: String {
        return "shakeAnimation"
    }
    
    func shake() {
        guard self.layer.animation(forKey: self.animationKey) == nil else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "position.x")
        
        animation.duration = 0.1
        animation.fromValue = self.center.x - 4
        animation.toValue = self.center.x + 4
        animation.autoreverses = true
        animation.repeatCount = 2
        
        self.layer.add(animation, forKey: self.animationKey)
    }
    
}

// MARK: - UIButton Animation
extension UIButton {
    
    func animate(text: String, newBackgroundColor: UIColor, animationSubType: String) {
        
        if self.layer.animation(forKey: kButtonAnimation) != nil {
            self.layer.removeAllAnimations()
        }
        
        let pushAnimation = CATransition()
        pushAnimation.duration = 0.5
        pushAnimation.type = kCATransitionPush
        pushAnimation.subtype = animationSubType
        self.titleLabel!.layer.add(pushAnimation, forKey: nil)
        
        self.setTitle(text, for: .disabled)
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = 0.5
        colorAnimation.fromValue = self.backgroundColor!.cgColor
        colorAnimation.toValue = newBackgroundColor
        self.layer.add(colorAnimation, forKey: kButtonAnimation)
        
        self.backgroundColor = newBackgroundColor
    }
    
}

// MARK: - UIView Animation
extension UIView {
    
    func comeIn(after delay: TimeInterval) {
        let animation = CASpringAnimation(keyPath: "position.x")
        animation.fromValue = -self.superview!.bounds.width/2 - self.bounds.width/2
        animation.toValue = self.superview!.bounds.width/2
        animation.damping = 14
        animation.fillMode = kCAFillModeBackwards
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = animation.settlingDuration
        self.layer.add(animation, forKey: nil)
    }
    
}


