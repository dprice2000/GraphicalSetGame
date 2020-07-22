//
//  Extensions.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/16/20.
//  Copyright © 2020 Dave. All rights reserved.
//
// keep all of the extensions here so they are easier to find
//

import Foundation
import UIKit

extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2 )
    } // zoom()
} // extension CGRect

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    } // offsetBy()
} // extension CGPoint

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    } // arc4random()
}  // extension Int

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    } // arc4random()
} // extension CGFloat
