//
//  UIViewControllerExtensions.swift
//  Date
//
//  Created by Josh Juster on 11/29/14.
//  Copyright (c) 2014 Josh Juster. All rights reserved.
//

import UIKit

private var hideableUIViewConstraintsKey: UInt8 = 0

extension UIView {
    private var _parentConstraintsReference: [AnyObject]! {
        get {
            return objc_getAssociatedObject(self, &hideableUIViewConstraintsKey) as? [AnyObject] ?? []
        }
        set {
            objc_setAssociatedObject(self, &hideableUIViewConstraintsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    internal func hide() {
        self.hidden = true
        
        if let parentView = self.superview where _parentConstraintsReference.count == 0 {
            //get the constraints that involve this view to re-add them when the view is shown
            if let parentConstraints = parentView.constraints as? [NSLayoutConstraint] {
                for parentConstraint in parentConstraints {
                    if parentConstraint.firstItem === self || parentConstraint.secondItem === self {
                        _parentConstraintsReference.append(parentConstraint)
                    }
                }
            }
            
            parentView.removeConstraints(_parentConstraintsReference as! [NSLayoutConstraint])
        }
    }
    
    internal func show() {
        //reapply any previously existing constraints
        if let parentView = self.superview {
            parentView.addConstraints(_parentConstraintsReference as! [NSLayoutConstraint])
        }
        
        _parentConstraintsReference = []
        self.hidden = false
    }
    
    static func constraintFormat(format: String, views: NSDictionary) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views as! [String : AnyObject])
    }
    
    internal func addConstraintFormat(format: String, views: NSDictionary) -> [NSLayoutConstraint] {
        let constraints = UIView.constraintFormat(format, views: views)
        self.addConstraints(constraints)
        return constraints
    }
    
    internal func addConstraintCenterX(item: UIView) -> [NSLayoutConstraint] {
        let constraint = NSLayoutConstraint(item: item, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    internal func addConstraintBottomMargin(item: UIView, margin: CGFloat) -> [NSLayoutConstraint] {
        let constraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: item, attribute: .BottomMargin, multiplier: 1.0, constant: margin)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    internal func addConstraintRightLeftMargin(item: UIView, margin: CGFloat) -> [NSLayoutConstraint] {
        let constraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: item, attribute: .LeftMargin, multiplier: 1.0, constant: margin)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    
    static func constraintWidth(item: UIView, width: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
    }
    
    internal func addConstraintWidth(item: UIView, width: CGFloat) -> [NSLayoutConstraint] {
        let constraint = UIView.constraintWidth(item, width: width)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    static func constraintHeight(item: UIView, height: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
    }
    
    internal func addConstraintHeight(item: UIView, height: CGFloat) -> [NSLayoutConstraint] {
        let constraint = UIView.constraintHeight(item, height: height)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    internal func addConstraintCenterY(item: UIView) -> [NSLayoutConstraint] {
        let constraint = NSLayoutConstraint(item: item, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        return [constraint]
    }
    
    internal func addConstraintAspectRatio(item: UIView, ratio: CGFloat) -> [NSLayoutConstraint] {
        let constraint = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: .Equal, toItem: item, attribute: .Width, multiplier: ratio, constant:0)
        self.addConstraint(constraint)
        return [constraint]
    }
}