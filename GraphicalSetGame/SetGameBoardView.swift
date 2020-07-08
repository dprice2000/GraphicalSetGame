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
        if numberOfCardSlotsAvailable < displayedCardViews.count {
            print("Not enough card slots for card views. -- slots = \(numberOfCardSlotsAvailable) - views \(displayedCardViews.count)")
            numberOfCardSlotsAvailable = displayedCardViews.count
        }
        grid.frame = rect
        grid.cellCount = numberOfCardSlotsAvailable
        
    }
    
}

extension SetGameBoardView  {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
} //SetGameBoardView Constants
