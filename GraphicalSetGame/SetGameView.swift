//
//  SetGameView.swift
//  GraphicalSetGame
//
//  Created by Dave on 1/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

@IBDesignable
class SetGameView: UIView {
    
    private var grid = Grid(layout: Grid.Layout.dimensions(rowCount: 3, columnCount: 4))

    private var cardViews = [SetCardView]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.orange.setFill()
        boardBackground.fill()
        grid.frame = bounds
        
        if cardViews.count == 0 {
        for _ in 0 ..< grid.cellCount {
            let aSetCardView = SetCardView()
                cardViews.append(aSetCardView)
        }
        }
        
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        for cardViewIndex in cardViews.indices {
            let cardView = cardViews[cardViewIndex]
            cardView.frame = grid[cardViewIndex]!.zoom(by: 0.95)
            addSubview(cardViews[cardViewIndex])
        }
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
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
