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
    var displayedCardViews = [SetCardView]() { didSet { setNeedsLayout() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawCardViews()
    }
    
    func redrawCardViews() {
        grid.frame = bounds
        grid.cellCount = displayedCardViews.count
        
        for view in subviews {  // clean up SetCardViews that have been moved to the discard pile.  (do this in discardPileView?) do we blow away the views in the discard pile?
            if let cardView = view as? SetCardView {
                if !displayedCardViews.contains(cardView) {
  //                  cardView.removeFromSuperview()
                    // fix this later
                }
            }
        }
        
        for (index, cardView) in displayedCardViews.enumerated() {
            if subviews.contains(cardView) == false {
                addSubview(cardView)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveEaseInOut],
                                                           animations: {
                                                            cardView.setNeedsDisplay()  // redraw the pips or they get too fat when the view enlarges
                                                            cardView.frame = self.grid[index]!.zoom(by: 0.95)
                                                            
            }, completion: { finished in
                if cardView.isFaceUp == false {  // don't flip a face up card.  It confuses the player
                    UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft],
                                      animations: {
                                        cardView.isFaceUp = true
                    })
                }
                
            })
        }
    }  // redrawCardViews() 
    
}

extension SetGameBoardView  {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
} //SetGameBoardView Constants
