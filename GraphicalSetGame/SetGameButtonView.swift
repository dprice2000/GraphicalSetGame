//
//  SetGameButtonView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

@IBDesignable
class SetGameButtonView: UIView {
    var font = UIFont.preferredFont(forTextStyle: .body).withSize(SetGameButtonView.buttonFontSize)
    private lazy var attributes:[NSAttributedString.Key:Any] = [
        .foregroundColor: SetGameButtonView.buttonFontColor,
        .font:font
    ]
    
    override func draw(_ rect: CGRect) {
        for subView in subviews {
            subView.removeFromSuperview()
        }

        // Drawing code
        var score = 0
        var enableDrawButton = true
        if let sgvc = findViewController() as? SetGameViewController {
            score = sgvc.getScore()
            enableDrawButton = sgvc.getDrawCardsAbility()
        }
        
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.lightGray.setFill()
        boardBackground.fill()
        
        var draw3CardsButtonBounds : CGRect
        var newGameButtonBounds : CGRect
        var remainingBounds : CGRect
        var scoreLabelBounds : CGRect

        // if I'm in portrait mode, stack my buttons
        // if I'm in landscape mode, my buttons are side by side        
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height  {
            (draw3CardsButtonBounds, remainingBounds) = bounds.divided(atDistance: bounds.size.height * 0.33, from: CGRectEdge.minYEdge)
            (newGameButtonBounds, scoreLabelBounds) = remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50 , from: CGRectEdge.minYEdge)
        } else {
            (scoreLabelBounds, remainingBounds) = bounds.divided(atDistance: bounds.size.width * 0.33 , from: CGRectEdge.minXEdge)
            (draw3CardsButtonBounds, newGameButtonBounds) = remainingBounds.divided(atDistance: remainingBounds.size.width * 0.50 , from: CGRectEdge.minXEdge)
        }

        var titleAttributedString = NSMutableAttributedString(string: "Draw 3 Cards", attributes: attributes)
        let draw3CardsButton = UIButton(type: .custom)
        let draw3CardsButtonCustomView = UIView(frame: draw3CardsButtonBounds)
        
        draw3CardsButtonCustomView.isUserInteractionEnabled = false
        draw3CardsButton.frame = draw3CardsButtonBounds
        draw3CardsButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
        draw3CardsButton.isEnabled = enableDrawButton
        draw3CardsButton.addSubview(draw3CardsButtonCustomView)
        draw3CardsButton.addTarget(self, action: #selector(draw3CardsAction), for: .touchUpInside)
        addSubview(draw3CardsButton)
        // TO DO: properly disable draw3cards button
        
        titleAttributedString = NSMutableAttributedString(string: "Start New Game", attributes: attributes)
        let newGameButton = UIButton(type: .custom)
        let newGameButtonCustomView = UIView(frame: newGameButtonBounds)

        newGameButtonCustomView.isUserInteractionEnabled = false
        newGameButton.frame = newGameButtonBounds
        newGameButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
        newGameButton.addSubview(newGameButtonCustomView)
        newGameButton.addTarget(self, action: #selector(newGameAction), for: .touchUpInside)
        addSubview(newGameButton)
        
        let scoreLabel = UILabel()
        titleAttributedString = NSMutableAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.frame = scoreLabelBounds
        scoreLabel.attributedText = titleAttributedString
        scoreLabel.textAlignment = NSTextAlignment.center
        addSubview(scoreLabel)
    }  // draw()
    
    @objc
    func draw3CardsAction() {
        if let sgvc = findViewController() as? SetGameViewController {
            sgvc.performDraw3Cards()
            sgvc.updateViewFromModel()
        }
    } //draw3CardsAction()
    
    @objc
    func newGameAction() {
        if let sgvc = findViewController() as? SetGameViewController {
            sgvc.performStartNewGame()
            sgvc.updateViewFromModel()
        }
    }  //newGameAction()
    
} //SetGameButtonView

extension SetGameButtonView {
    private static let buttonFontColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    private static let buttonFontSize : CGFloat = 30.0
}  // SetGameButtonView constants

