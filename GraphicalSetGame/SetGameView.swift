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
    
//    var grid = Grid(layout: Grid.Layout.aspectRatio(SetGameView.cardAspectRatio))
//    private(set) var cardViews = [SetCardView]()
//    var font = UIFont.preferredFont(forTextStyle: .body).withSize(SetGameView.buttonFontSize)
//    private lazy var attributes:[NSAttributedString.Key:Any] = [
//        .foregroundColor: SetGameView.buttonFontColor,
//        .font:font
//    ]
//    var drawButtonBounds: CGRect!
//    var drawButton: UIButton!
//    
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//
//        for subView in subviews {
//            subView.removeFromSuperview()
//        }
//        
//        var score = 0
//        var enableDrawButton = false
//        let gameBackground = UIBezierPath(rect: bounds)
//        SetGameView.backgroundColor.setFill()
//        gameBackground.fill()
//
//        let (setGameBoardBounds, setGameButtonBounds) = bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)
//        let gameBoardBackground = UIBezierPath(rect: setGameBoardBounds)
//        SetGameView.boardBackgroundColor.setFill()
//        gameBoardBackground.fill()
//
//        grid.frame = setGameBoardBounds
//        if let sgvc = findViewController()  as? SetGameViewController {
//            grid.cellCount = sgvc.getBoardSize()
////            for cardViewIndex in 0 ..< grid.cellCount {
////                let cardAttributes = sgvc.getAttributesFromCardID(cardViewIndex)
////                let aSetCardView = SetCardView(frame: grid[cardViewIndex]!.zoom(by: 0.95),cardViewID: cardViewIndex, cardAttributes: cardAttributes)
////                cardViews.append(aSetCardView)
////                addSubview(aSetCardView)
////            }
//            score = sgvc.getScore()
//            enableDrawButton = sgvc.getDrawCardsAbility()
//        }
//
//        var drawDeckButtonBounds : CGRect
//        var discardPileBounds : CGRect
//        var newGameButtonBounds : CGRect
//        var scoreLabelBounds : CGRect
//        var remainingBounds : CGRect
//
//        (drawDeckButtonBounds, remainingBounds) =
//            setGameButtonBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameView.cardAspectRatio, from: CGRectEdge.minXEdge)
//        (discardPileBounds, remainingBounds) =
//            remainingBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameView.cardAspectRatio, from: CGRectEdge.minXEdge)
//        (newGameButtonBounds,scoreLabelBounds) =
//            remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50, from: CGRectEdge.minYEdge)
//        
//drawButtonBounds = drawDeckButtonBounds
//        let draw3CardsButton = UIButton(type: .custom)
//        let draw3CardsButtonCustomView = UIView(frame: drawDeckButtonBounds)
//        
//        draw3CardsButtonCustomView.isUserInteractionEnabled = false
//        draw3CardsButton.frame = drawDeckButtonBounds
//        renderDrawDeck(inFrame: drawDeckButtonBounds, isEnabled: enableDrawButton)
//        draw3CardsButton.addTarget(self, action: #selector(draw3CardsAction), for: .touchUpInside)
//        addSubview(draw3CardsButton)
//drawButton = draw3CardsButton
//        
//        let discardPileView = UIView(frame: discardPileBounds)
//        
//        renderDiscardPile(inFrame: discardPileBounds)
//        addSubview(discardPileView)
//        
//        var titleAttributedString = NSMutableAttributedString(string: "New Game", attributes: attributes)
//        let newGameButton = UIButton(type: .custom)
//        let newGameButtonCustomView = UIView(frame: newGameButtonBounds)
//        
//
//        newGameButtonCustomView.isUserInteractionEnabled = false
//        newGameButton.frame = newGameButtonBounds
//        newGameButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
//        newGameButton.addSubview(newGameButtonCustomView)
//        newGameButton.addTarget(self, action: #selector(newGameAction), for: .touchUpInside)
//        addSubview(newGameButton)
//        
//        let scoreLabel = UILabel()
//        titleAttributedString = NSMutableAttributedString(string: "Score: \(score)", attributes: attributes)
//        scoreLabel.frame = scoreLabelBounds
//        scoreLabel.attributedText = titleAttributedString
//        scoreLabel.textAlignment = NSTextAlignment.center
//        addSubview(scoreLabel)
//
//    } // draw
//    
//    private func renderDrawDeck(inFrame: CGRect, isEnabled: Bool) {
//        let backgroundRect = UIBezierPath(rect: inFrame)
//        SetGameView.boardBackgroundColor.setFill()
//        backgroundRect.fill()
//        if ( isEnabled == true) {
//            let outterRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.95), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
//            SetCardView.greenCardColor.setFill()
//                outterRoundedRect.fill()
//            let midRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.75), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
//            SetCardView.redCardColor.setFill()
//            midRoundedRect.fill()
//            let innerRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.50), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
//            SetCardView.blueCardColor.setFill()
//            innerRoundedRect.fill()
//        } else {
//            let outterRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.95), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
//            SetGameView.buttonFontColor.setStroke()
//            outterRoundedRect.stroke()
//        }
//    }
//    
//    private func renderDiscardPile(inFrame: CGRect) {
//        if let sgvc = findViewController()  as? SetGameViewController {
//            if let topOfDiscardPileAttributes = sgvc.getTopOfDiscardPile() {
//                let aSetCardView = SetCardView(frame: inFrame,  cardViewID: nil, cardAttributes: topOfDiscardPileAttributes)
//                addSubview(aSetCardView)
//                return
//            }
//        }
//        let backgroundRect = UIBezierPath(rect: inFrame)
//        SetGameView.boardBackgroundColor.setFill()
//        backgroundRect.fill()
//        let outterRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.95), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
//        SetGameView.buttonFontColor.setStroke()
//        outterRoundedRect.lineWidth = 5.0
//        outterRoundedRect.stroke()
//        SetGameView.backgroundColor.setFill()
//        outterRoundedRect.fill()
//    }
//    
//    @objc
//    func draw3CardsAction() {
//        if let sgvc = findViewController() as? SetGameViewController {
//            sgvc.performDraw3Cards()
//            sgvc.updateViewFromModel()
//        }
//    } //draw3CardsAction()
//    
//    @objc
//    func newGameAction() {
//        if let sgvc = findViewController() as? SetGameViewController {
//            sgvc.performStartNewGame()
//            sgvc.updateViewFromModel()
//        }
//    }  //newGameAction()
    
} // setGameView





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
} // extension UIView
