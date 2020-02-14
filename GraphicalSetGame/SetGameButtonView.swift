//
//  SetGameButtonView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

// if I'm in portrait mode, stack my buttons
// if I'm in landscape mode, my buttons are side by side

import UIKit

@IBDesignable
class SetGameButtonView: UIView {
    private lazy var scoreLabel: UILabel = UILabel()

    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.green.setFill()
        boardBackground.fill()
        
        let (draw3CardsButtonBounds, remainingBounds) = bounds.divided(atDistance: bounds.size.height * 0.33, from: CGRectEdge.minYEdge)
        let (newGameButtonBounds, scoreLabelBounds) = remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50 , from: CGRectEdge.minYEdge)
        
        let draw3CardsButton = UIButton(type: .custom)
        let draw3CardsButtonCustomView = UIView(frame: draw3CardsButtonBounds)
        draw3CardsButtonCustomView.isUserInteractionEnabled = false
        draw3CardsButton.frame = draw3CardsButtonBounds
        draw3CardsButton.setTitle("draw 3 cards", for: UIControl.State.normal)
        draw3CardsButton.addSubview(draw3CardsButtonCustomView)
        draw3CardsButton.addTarget(self, action: #selector(draw3CardsAction), for: .touchUpInside)
        addSubview(draw3CardsButton)

        let newGameButton = UIButton(type: .custom)
        let newGameButtonCustomView = UIView(frame: newGameButtonBounds)
        newGameButtonCustomView.isUserInteractionEnabled = false
        newGameButton.frame = newGameButtonBounds
        newGameButton.setTitle("start new game", for: UIControl.State.normal)
        newGameButton.addSubview(newGameButtonCustomView)
        newGameButton.addTarget(self, action: #selector(newGameAction), for: .touchUpInside)
        addSubview(newGameButton)
        
        scoreLabel.frame = scoreLabelBounds
        scoreLabel.text = "score: 0"
        addSubview(scoreLabel)
    }
    
    @objc
    func draw3CardsAction() {
        print("Click Draw 3 Cards")
    }
    
    @objc
    func newGameAction() {
        print("Click Start New Game")
    }
    
}
