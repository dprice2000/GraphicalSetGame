//
//  ViewController.swift
//  GraphicalSetGame
//
//  Created by Dave on 1/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {

    @IBOutlet weak var mainViewOutlet: UIView!

    var font = UIFont.preferredFont(forTextStyle: .body).withSize(SetGameViewController.buttonFontSize)
    private lazy var attributes:[NSAttributedString.Key:Any] = [
        .foregroundColor: SetGameViewController.buttonFontColor,
        .backgroundColor: SetGameViewController.backgroundColor,
        .font:font
    ]
    
    private lazy var game = SetGame(boardSize: 12)

    private var drawDeckView: DrawDeckView!
    private var discardPileView: DiscardPileView!
    private var setGameBoardView: SetGameBoardView!
    
    private var newGameButton: UIButton!
    private var scoreLabel: UILabel!
    
    private var score = 0 {
        didSet {
            let labelAttributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
            scoreLabel.attributedText = labelAttributedString
        }
    }
    
    private var startingCardViewFrame: CGRect!
    private var discardPileFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewOutlet.backgroundColor = SetGameViewController.boardBackgroundColor
        let (setGameBoardFrame, setGameButtonFrame) = mainViewOutlet.bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)
        setGameBoardView = SetGameBoardView(frame: setGameBoardFrame)
        mainViewOutlet.addSubview(setGameBoardView)
        
        var drawDeckButtonFrame : CGRect
        var newGameButtonFrame : CGRect
        var scoreLabelFrame : CGRect
        var remainingFrame : CGRect
        
        (drawDeckButtonFrame, remainingFrame) =
            setGameButtonFrame.divided(atDistance: setGameButtonFrame.size.height * SetGameViewController.cardAspectRatio, from: CGRectEdge.minXEdge)
        (discardPileFrame, remainingFrame) =
            remainingFrame.divided(atDistance: setGameButtonFrame.size.height * SetGameViewController.cardAspectRatio, from: CGRectEdge.minXEdge)
        (newGameButtonFrame,scoreLabelFrame) =
            remainingFrame.divided(atDistance: remainingFrame.size.height * 0.50, from: CGRectEdge.minYEdge)

        drawDeckView = DrawDeckView(frame: drawDeckButtonFrame)
        drawDeckView.isEnabled = game.moreCardsToDeal()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(drawDeckViewTapped(_:)))
        drawDeckView.addGestureRecognizer(recognizer)
        mainViewOutlet.addSubview(drawDeckView)
        startingCardViewFrame = drawDeckButtonFrame
        
        discardPileView = DiscardPileView(frame: discardPileFrame)
        mainViewOutlet.addSubview(discardPileView)
        mainViewOutlet.sendSubviewToBack(discardPileView)
        
        var titleAttributedString = NSAttributedString(string: "New Game", attributes: attributes)
        newGameButton = UIButton(type: .custom)
        newGameButton.frame = newGameButtonFrame.zoom(by: 0.95)
        newGameButton.backgroundColor = SetGameViewController.backgroundColor
        newGameButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        mainViewOutlet.addSubview(newGameButton)
        
        scoreLabel = UILabel()
        titleAttributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.frame = scoreLabelFrame.zoom(by: 0.95)
        scoreLabel.backgroundColor = SetGameViewController.backgroundColor
        scoreLabel.attributedText = titleAttributedString
        scoreLabel.textAlignment = NSTextAlignment.center
        mainViewOutlet.addSubview(scoreLabel)        
    } //viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) {
        updateViewFromModel()
    }

    // build an array of all set card views to be displayed and pass it to the SetGameBoardView
    // to be displayed.
    func updateViewFromModel() {
        var cardViews = [SetCardView]()
        var discardedViews = [SetCardView]()
        
        // if the game has matched cards,
        // move their views to the discard pile
        // have the game replace them now, so we can generate their views.
        
        if game.matchedCards.count == 3 {
            for matchedCard in game.matchedCards {
                let matchedCardView = getViewForSetCard(matchedCard)
                discardedViews.append(matchedCardView)
                throwAwayMatchedCard(matchedCardView)
            }
            game.replaceMatchedCards()
        }

        // get the views for all of the drawn cards
        for card in game.drawnCards {
            let cardView = getViewForSetCard(card)
            cardViews.append(cardView)
        }
        
        score = game.score
        setGameBoardView.displayedCardViews = cardViews
    } //updateViewFromModel()
    
    func getViewForSetCard(_ card: SetCard) -> SetCardView {
        let cardView = SetCardView(frame: startingCardViewFrame, cardAttributes: card.getCardAttributes())
        let viewForCard = setGameBoardView.displayedCardViews.filter { $0.shape == cardView.shape &&
                                                                       $0.shading == cardView.shading &&
                                                                       $0.pipCount == cardView.pipCount &&
                                                                       $0.cardColor == cardView.cardColor }
        
        if viewForCard.isEmpty {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped(_:)))
            cardView.addGestureRecognizer(recognizer)
            return cardView
        } else {
            return viewForCard[0]
        }
    }

    func throwAwayMatchedCard(_ view: SetCardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [.curveEaseInOut] ,
                                                       animations: {
                                                        view.setNeedsDisplay()
                                                        view.frame = self.discardPileFrame.zoom(by: 0.95)
        }, completion: { finished in
            if self.discardPileView.topCardView != nil {
                self.discardPileView.topCardView?.removeFromSuperview()
            }
            self.discardPileView.topCardView = view
        })
    }
    
    @objc func cardViewTapped(_ recognizer: UITapGestureRecognizer) {
        assert(game.drawnCards.count <= setGameBoardView.displayedCardViews.count, "Too many cards, not enough views.")
        
        if let cardView = recognizer.view as? SetCardView,
            let cardViewIndex = setGameBoardView.displayedCardViews.firstIndex(of: cardView) {
            game.selectCard(atIndex: cardViewIndex)
            for index in game.drawnCards.indices {
                /* If 3 cards are selected and we select a fourth card, then the selected cards are unselected and the fourth card is selected.  So 4 cards can change state, we need to loop through all of the views and make them show the correct selection. */
                if game.isCardSelected(index) != setGameBoardView.displayedCardViews[index].isSelected {
                    setGameBoardView.displayedCardViews[index].isSelected.toggle()
                }
            }
            if game.matchedCards.count == 3 {
                updateViewFromModel()
            }
            score = game.score
        }
    }
    
    @objc func drawDeckViewTapped(_ recognizer: UITapGestureRecognizer) {
        if game.moreCardsToDeal() == false {
            return
        }
        game.dealThreeCards()
        if game.moreCardsToDeal() == false {
            drawDeckView.isEnabled = false
        }
        score = game.score
        updateViewFromModel()
    }
    
    @objc func newGameButtonTapped(_ sender: UIButton) {
        setGameBoardView.resetForNewGame()
        game.startNewGame()
        updateViewFromModel()
    }
    
    @objc func performCardShuffle(_ recognizer : UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shuffleDrawnCards()
            updateViewFromModel()
        default:
            break
        }
    } // performCardShuffle(_ recognizer: UIRotationGestureRecognizer
        
} //SetGameViewController

extension SetGameViewController {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
    static let boardHeightToBoundsRatio: CGFloat = 0.75
    var boardBoundry: CGFloat {
        return mainViewOutlet.bounds.size.height * SetGameViewController.boardHeightToBoundsRatio
    }
    static let buttonFontColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    static let buttonFontSize : CGFloat = 30.0
    static let backgroundColor = UIColor.lightGray
    static let boardBackgroundColor = UIColor.black
} //SetGameViewController Constants

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
