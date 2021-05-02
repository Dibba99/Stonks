//
//  AnimView.swift
//  Momaps
//
//  Created by Cosmo on 4/28/21.
//

import UIKit

class ViewAnimator: UIView {
    
    enum Direction: Int {
        case FromLeft = 0
        case FromRight = 1
    }
    @IBInspectable var direction: Int = 0
    @IBInspectable var delay: Double = 0.0
    
    override func layoutSubviews() {
        initAnimation()
        UIView.animate(withDuration: 0.5, delay: self.delay, options: .curveEaseIn, animations: {
            if let s = self.superview{
                if self.direction == Direction.FromLeft.rawValue{
                    self.center.y += s.bounds.width
                }else{
                    self.center.y -= s.bounds.width
                }
            }
        }, completion: nil)
        
    }
    
    func initAnimation(){
        if let s = self.superview{
            if direction == Direction.FromLeft.rawValue{
                self.center.y -= s.bounds.width
            }else{
                self.center.y += s.bounds.width
            }
        }
    }
}
