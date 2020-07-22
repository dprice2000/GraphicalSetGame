//
//  SetGameBoardView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//
// This view holds all of the displayed card views.  The grid for the card views changes as cards are added to or removed
// from the board view.  Cards smoothly move to their new positions in the view.  Blindly moving the card view from where it was
// to where it should be also covers the case of moving cards up from their starting position over the DrawDeckView.  Just flip them
// if they are face down.  This approach also handles repositioning shuffled cards

import UIKit

@IBDesignable
class SetGameBoardView: UIView {
    private var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardAspectRatio))
    var displayedCardViews = [SetCardView]() { didSet { setNeedsLayout() }}  // force layout when the card views array is updated
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redrawCardViews()
    }
    
    // move all of the views from where they are to where they should be on the game board.
    private func redrawCardViews() {
        grid.frame = bounds
        grid.cellCount = displayedCardViews.count
        
        for (index, cardView) in displayedCardViews.enumerated() {
            if subviews.contains(cardView) == false {
                addSubview(cardView)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.cardMoveDuration,
                                                           delay: Constants.animationDelay,
                                                           options: [.curveEaseInOut],
                                                           animations: { [weak cardView] in
                                                            cardView?.setNeedsDisplay()  // force the cardView to redraw (corners and pips change as the cards get bigger or smaller
                                                            cardView?.frame = self.grid[index]!.zoom(by: 0.95)
                                                            
            }, completion: { [weak cardView] finished in
                if cardView?.isFaceUp == false {  // don't flip a face up card.  It confuses the player
                    UIView.transition(with: cardView!, duration: Constants.cardFlipDuration, options: [.transitionFlipFromLeft],
                                      animations: {
                                        cardView?.isFaceUp = true
                    })
                }
                
            })
        }
    }  // redrawCardViews()
    
    // when there is a new game, release all of the subviews, and empty the displayedCardViews array
    func resetForNewGame() {
        for view in subviews {
            if let cardView = view as? SetCardView {
                cardView.removeFromSuperview()
            }
        }
        displayedCardViews.removeAll()
    } // resetFornewGame()
}
