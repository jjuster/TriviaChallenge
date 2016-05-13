//
//  UIImageExtensions.swift
//  Trivia Challenge
//
//  Created by Josh Juster on 5/12/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit

extension UIImage {
    internal func scaleTo(scale: CGFloat) -> UIImage {
        let newSize = CGSizeMake(self.size.width / scale, self.size.height / scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}