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
    
    
    var grid = Grid(layout: Grid.Layout.aspectRatio(SetGameBoardView.cardAspectRatio))
    var displayedCardViews = [SetCardView]()
    var numberOfCardSlotsAvailable = 0
    
    override func draw(_ rect: CGRect) {
        // clean out existing views
        for view in subviews {
            view.removeFromSuperview()
        }
        // error check and correct
        if numberOfCardSlotsAvailable < displayedCardViews.count {
            print("Not enough card slots for card views. -- slots = \(numberOfCardSlotsAvailable) - views \(displayedCardViews.count)")
            numberOfCardSlotsAvailable = displayedCardViews.count
        }
        grid.frame = rect
        grid.cellCount = numberOfCardSlotsAvailable
        
        // add the displayed card views back in to the view.  Note that when the number of cards changes, the bounds of each card view will change
        // so we have to remove and then readd with new bounds.
        for cardViewIndex in displayedCardViews.indices {
            displayedCardViews[cardViewIndex].bounds = grid[cardViewIndex]!
            addSubview(displayedCardViews[cardViewIndex])
        }
        
    }
    

    
}

extension SetGameBoardView  {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
} //SetGameBoardView Constants
