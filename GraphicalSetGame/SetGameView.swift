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
    
    private var grid = Grid(layout: Grid.Layout.aspectRatio(SetGameView.cardAspectRatio))
    private var cardViews = [SetCardView]()
    var font = UIFont.preferredFont(forTextStyle: .body).withSize(SetGameView.buttonFontSize)
    private lazy var attributes:[NSAttributedString.Key:Any] = [
        .foregroundColor: SetGameView.buttonFontColor,
        .font:font
    ]


    override func draw(_ rect: CGRect) {
        // Drawing code

        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        var score = 0
        var enableDrawButton = true

        let gameBackground = UIBezierPath(rect: bounds)
        SetGameView.backgroundColor.setFill()
        gameBackground.fill()

        let (setGameBoardBounds, setGameButtonBounds) = bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)
        let gameBoardBackground = UIBezierPath(rect: setGameBoardBounds)
        SetGameView.boardBackgroundColor.setFill()
        gameBoardBackground.fill()

        grid.frame = setGameBoardBounds
        if let sgvc = findViewController()  as? SetGameViewController {
            grid.cellCount = sgvc.getBoardSize()
            for cardViewIndex in 0 ..< grid.cellCount {
                let cardAttributes = sgvc.getAttributesFromCardID(cardViewIndex)
                let aSetCardView = SetCardView(frame: grid[cardViewIndex]!.zoom(by: 0.95),cardViewID: cardViewIndex, cardAttributes: cardAttributes)
                cardViews.append(aSetCardView)
                addSubview(aSetCardView)
            }
            score = sgvc.getScore()
            enableDrawButton = sgvc.getDrawCardsAbility()
        }

        var drawDeckButtonBounds : CGRect
        var discardPileBounds : CGRect
        var newGameButtonBounds : CGRect
        var scoreLabelBounds : CGRect
        var remainingBounds : CGRect

        (drawDeckButtonBounds, remainingBounds) = setGameButtonBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameView.cardAspectRatio, from: CGRectEdge.minXEdge)
        (discardPileBounds, remainingBounds) = remainingBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameView.cardAspectRatio, from: CGRectEdge.minXEdge)
        // if I'm in portrait mode, stack my buttons
        // if I'm in landscape mode, my buttons are side by side
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
        (newGameButtonBounds,scoreLabelBounds) = remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50, from: CGRectEdge.minYEdge)
        } else {
            (newGameButtonBounds,scoreLabelBounds) = remainingBounds.divided(atDistance: remainingBounds.size.width * 0.50, from: CGRectEdge.minXEdge)
        }
        
        let draw3CardsButton = UIButton(type: .custom)
        let draw3CardsButtonCustomView = UIView(frame: drawDeckButtonBounds)
        
        draw3CardsButtonCustomView.isUserInteractionEnabled = false
        draw3CardsButton.frame = drawDeckButtonBounds
        renderDrawDeck(inFrame: drawDeckButtonBounds)
        draw3CardsButton.isEnabled = enableDrawButton
        draw3CardsButton.addSubview(draw3CardsButtonCustomView)
        draw3CardsButton.addTarget(self, action: #selector(draw3CardsAction), for: .touchUpInside)
        addSubview(draw3CardsButton)
        
        var titleAttributedString = NSMutableAttributedString(string: "New Game", attributes: attributes)
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

    } // draw
    
    private func renderDrawDeck(inFrame: CGRect) {
        let backgroundRect = UIBezierPath(rect: inFrame)
        SetGameView.boardBackgroundColor.setFill()
        backgroundRect.fill()
        let outterRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.95), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.greenCardColor.setFill()
            outterRoundedRect.fill()
        let midRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.75), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.redCardColor.setFill()
        midRoundedRect.fill()
        let innerRoundedRect = UIBezierPath(roundedRect: inFrame.zoom(by: 0.50), cornerRadius: inFrame.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.blueCardColor.setFill()
        innerRoundedRect.fill()
    }
    
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

    
    
    
} // setGameView

extension SetGameView {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
    static let boardHeightToBoundsRatio: CGFloat = 0.75
    private var boardBoundry: CGFloat {
        return bounds.size.height * SetGameView.boardHeightToBoundsRatio
    }
    private static let buttonFontColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    private static let buttonFontSize : CGFloat = 30.0
    private static let backgroundColor = UIColor.lightGray
    private static let boardBackgroundColor = UIColor.black
} //SetGameView Constants


extension CGRect {
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
