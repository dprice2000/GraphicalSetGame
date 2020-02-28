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
    private lazy var attributes:[NSAttributedString.Key:Any] = [
        .foregroundColor: UIColor.red,
        .font:UIFont(name: scoreLabel.font.fontName, size: 30.0)!
    ]  // better way to get the fontName? look in playing card example

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.green.setFill()
        boardBackground.fill()
 // blow away sub views?
        let attributes:[NSAttributedString.Key:Any] = [
            .foregroundColor: UIColor.red,
            .font:UIFont(name: scoreLabel.font.fontName, size: 30.0)!
        ]  // better way to get fontName?
        
        var draw3CardsButtonBounds : CGRect
        var newGameButtonBounds : CGRect
        var remainingBounds : CGRect
        var scoreLabelBounds : CGRect

        if UIScreen.main.bounds.width < UIScreen.main.bounds.height  {
            (draw3CardsButtonBounds, remainingBounds) = bounds.divided(atDistance: bounds.size.height * 0.33, from: CGRectEdge.minYEdge)
            (newGameButtonBounds, scoreLabelBounds) = remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50 , from: CGRectEdge.minYEdge)
        } else {
            (scoreLabelBounds, remainingBounds) = bounds.divided(atDistance: bounds.size.width * 0.33 , from: CGRectEdge.minXEdge)
            (draw3CardsButtonBounds, newGameButtonBounds) = remainingBounds.divided(atDistance: remainingBounds.size.width * 0.50 , from: CGRectEdge.minXEdge)
        }

        var myAttributedString = NSMutableAttributedString(string: "Draw 3 Cards", attributes: attributes)

        let draw3CardsButton = UIButton(type: .custom)
        let draw3CardsButtonCustomView = UIView(frame: draw3CardsButtonBounds)
        draw3CardsButtonCustomView.isUserInteractionEnabled = false
        draw3CardsButton.frame = draw3CardsButtonBounds
        draw3CardsButton.setAttributedTitle(myAttributedString, for: UIControl.State.normal)
        draw3CardsButton.addSubview(draw3CardsButtonCustomView)
        draw3CardsButton.addTarget(self, action: #selector(draw3CardsAction), for: .touchUpInside)
        addSubview(draw3CardsButton)
        
        myAttributedString = NSMutableAttributedString(string: "Start New Game", attributes: attributes)
        let newGameButton = UIButton(type: .custom)
        let newGameButtonCustomView = UIView(frame: newGameButtonBounds)
        newGameButtonCustomView.isUserInteractionEnabled = false // why?
        newGameButton.frame = newGameButtonBounds
        newGameButton.setAttributedTitle(myAttributedString, for: UIControl.State.normal)
        newGameButton.addSubview(newGameButtonCustomView)
        newGameButton.addTarget(self, action: #selector(newGameAction), for: .touchUpInside)
        addSubview(newGameButton)
        
        if let mySGVC = findViewController() as? SetGameViewController {
            myAttributedString = NSMutableAttributedString(string: "Score: \(mySGVC.clickCount)", attributes: attributes)
            scoreLabel.attributedText = myAttributedString
        } else {
            myAttributedString = NSMutableAttributedString(string: "Score: 0", attributes: attributes)
        }
        scoreLabel.frame = scoreLabelBounds
        scoreLabel.attributedText = myAttributedString
        scoreLabel.textAlignment = NSTextAlignment.center
        addSubview(scoreLabel)
    }
    
    @objc
    func draw3CardsAction() {
        if let mySGVC = findViewController() as? SetGameViewController {
            mySGVC.performDraw3Cards()
            mySGVC.updateViewFromModel()
        }
        print("Click Draw 3 Cards")
    }
    
    @objc
    func newGameAction() {
        if let mySGVC = findViewController() as? SetGameViewController {
            let myAttributedString = NSMutableAttributedString(string: "Score: \(mySGVC.incrementClickCount())", attributes: attributes)
            scoreLabel.attributedText = myAttributedString
        }
        print("Click Start New Game")
    }
    
}

