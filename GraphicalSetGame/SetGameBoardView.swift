//
//  SetGameBoardView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

@IBDesignable
class SetGameBoardView: UIView {

    private var grid = Grid(layout: Grid.Layout.dimensions(rowCount: 3, columnCount: 4))
    
    private var cardViews = [SetCardView]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.blue.setFill()
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
    } // draw

}
