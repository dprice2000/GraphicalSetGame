//
//  SetGameView.swift
//  GraphicalSetGame
//
//  Created by Dave on 1/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//

//  portrait mode: buttons stacked
//  landscape mode: buttons side by side

import UIKit

@IBDesignable
class SetGameView: UIView {

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        setNeedsLayout()
//        setNeedsDisplay()
//    }


    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let (setGameBoardBounds, setGameButtonBounds) = bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)

        let aSetGameBoardView = SetGameBoardView(frame: setGameBoardBounds)
        let aSetGameButtonView = SetGameButtonView(frame: setGameButtonBounds)
        
        for subView in subviews {
            subView.removeFromSuperview()
        }

        addSubview(aSetGameBoardView)
        addSubview(aSetGameButtonView)
    }
    
} // setGameView


extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: midY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2 )
    }
} // extension CGRect

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
} // extension CGPoint

extension SetGameView {
    private struct SizeRatio {
        static let boardHeightToBoundsRatio: CGFloat = 0.75
    }

    private var boardBoundry: CGFloat {
        return bounds.size.height * SizeRatio.boardHeightToBoundsRatio
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
