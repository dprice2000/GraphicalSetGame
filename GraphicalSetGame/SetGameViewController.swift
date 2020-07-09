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
    private var cardViews = [SetCardView]()

    private var drawDeckView: DrawDeckView!
    private var setGameBoardView: SetGameBoardView!
    
    private var newGameButton: UIButton!
    private var scoreLabel: UILabel!
    
    private var score = 0
    private var startingCardViewBounds: CGRect!
    private var discardPileBounds: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewOutlet.backgroundColor = SetGameViewController.boardBackgroundColor
        let (setGameBoardBounds, setGameButtonBounds) = mainViewOutlet.bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)
        setGameBoardView = SetGameBoardView(frame: setGameBoardBounds)
        setGameBoardView.numberOfCardSlotsAvailable = getBoardSize()
        mainViewOutlet.addSubview(setGameBoardView)
        
        var drawDeckButtonBounds : CGRect
        var newGameButtonBounds : CGRect
        var scoreLabelBounds : CGRect
        var remainingBounds : CGRect
        
        (drawDeckButtonBounds, remainingBounds) =
            setGameButtonBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameViewController.cardAspectRatio, from: CGRectEdge.minXEdge)
        (discardPileBounds, remainingBounds) =
            remainingBounds.divided(atDistance: setGameButtonBounds.size.height * SetGameViewController.cardAspectRatio, from: CGRectEdge.minXEdge)
        (newGameButtonBounds,scoreLabelBounds) =
            remainingBounds.divided(atDistance: remainingBounds.size.height * 0.50, from: CGRectEdge.minYEdge)

        drawDeckView = DrawDeckView(frame: drawDeckButtonBounds)
        drawDeckView.isEnabled = getDrawCardsAbility()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(drawDeckViewTapped(_:)))
        drawDeckView.addGestureRecognizer(recognizer)
        mainViewOutlet.addSubview(drawDeckView)
        startingCardViewBounds = drawDeckButtonBounds
        
        
        var titleAttributedString = NSMutableAttributedString(string: "New Game", attributes: attributes)
        newGameButton = UIButton(type: .custom)
        newGameButton.frame = newGameButtonBounds.zoom(by: 0.95)
        newGameButton.backgroundColor = SetGameViewController.backgroundColor
        newGameButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
//        newGameButton.addTarget(self, action: #selector(newGameAction), for: .touchUpInside)
        mainViewOutlet.addSubview(newGameButton)
        
        scoreLabel = UILabel()
        titleAttributedString = NSMutableAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.frame = scoreLabelBounds.zoom(by: 0.95)
        scoreLabel.backgroundColor = SetGameViewController.backgroundColor
        scoreLabel.attributedText = titleAttributedString
        scoreLabel.textAlignment = NSTextAlignment.center
        mainViewOutlet.addSubview(scoreLabel)

        
    } //viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) {
        moveDrawnCardToBoard(0)
    }
    
    //
    func moveDrawnCardToBoard(_ index: Int) {
        if index >= game.drawnCards.count {
            return
        }
        let cardAttributes = game.drawnCards[index].getCardAttributes()
        let cardView = SetCardView(frame: startingCardViewBounds, cardViewID: index, cardAttributes: cardAttributes)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped(_:)))
        cardView.addGestureRecognizer(recognizer)
        setGameBoardView.addSubview(cardView)
        setGameBoardView.displayedCardViews.append(cardView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveEaseInOut],
                                                       animations: {
                                                        cardView.frame = self.setGameBoardView.grid[index]!.zoom(by: 0.95)
        }, completion: { finished in
            UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft],
                              animations: {
                                cardView.isFaceUp = true
            }, completion: { finished in
                self.moveDrawnCardToBoard(index+1)
            })
            
        })
    }
    
    func moveReplacementCardToBoard(atIndex index: Int) {
        let cardAttributes = game.drawnCards[index].getCardAttributes()
        let cardView = SetCardView(frame: startingCardViewBounds, cardViewID: index, cardAttributes: cardAttributes)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped(_:)))
        cardView.addGestureRecognizer(recognizer)
        setGameBoardView.addSubview(cardView)
        setGameBoardView.displayedCardViews.append(cardView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveEaseInOut],
                                                       animations: {
                                                        cardView.frame = self.setGameBoardView.grid[index]!.zoom(by: 0.95)
        }, completion: { finished in
            UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft],
                              animations: {
                                cardView.isFaceUp.toggle()
            }, completion: { finished in
                self.replaceNextMatchedCard(atIndex: index+1)
            })
        })
    }
    
    func replaceNextMatchedCard(atIndex index: Int) {
        if game.matchedCards.count == 0 {
            return
        }
        if index >= game.drawnCards.count {
            return
        }
        if game.isCardMatched(index) {
            game.replaceMatchedCard(atIndex: index)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [.curveEaseInOut] ,
                                                           animations: {
                                                            self.setGameBoardView.displayedCardViews[index].frame = self.discardPileBounds.zoom(by: 0.95)
            }, completion: { finished in
                self.moveReplacementCardToBoard(atIndex: index)
            })
        } else {
            replaceNextMatchedCard(atIndex: index+1)
        }
        
    }
    // move the old card view to the discard pile
    // make a new view from the new card at index
    // move the new card into the space of the old card

    @objc func cardViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let cardView = recognizer.view as? SetCardView, let cardIndex = cardView.cardViewIdentifier {
            game.selectCard(atIndex: cardIndex)
            if game.matchedCards.count == 3 {
                replaceNextMatchedCard(atIndex: 0)
                return
            }
            for index in game.drawnCards.indices {
                /* If 3 cards are selected and we select a fourth card, then the selected cards are unselected and the fourth card is selected.  So 4 cards can change state, we need to loop through all of the views and make them show the correct selection. */
                if game.isCardSelected(index) != setGameBoardView.displayedCardViews[index].isSelected {
                    UIView.transition(with: cardView, duration: 0.5, options: .transitionCrossDissolve,
                                      animations: {
                                        self.setGameBoardView.displayedCardViews[index].isSelected.toggle()
                    })
                }

            }
        }
            
    }
    
    @objc func drawDeckViewTapped(_ recognizer: UITapGestureRecognizer) {
        UIView.transition(with: setGameBoardView, duration: 0.5, options: .transitionCrossDissolve,
                          animations: {
                            self.setGameBoardView.numberOfCardSlotsAvailable += 3
                            self.setGameBoardView.setNeedsLayout()
                            self.setGameBoardView.setNeedsDisplay()
        }, completion: { finished in
            self.game.dealThreeCards()
            self.moveDrawnCardToBoard(self.setGameBoardView.displayedCardViews.count)
        })
        
        
    }
    
    func getBoardSize() -> Int {
        return game.drawnCards.count
    } //getBoardSize() -> Int
    
    @objc func performDraw3Cards(_ recognizer : UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shuffleDrawnCards()
        default:
            break
        }
        updateViewFromModel()
    } // performDeal3Cards(_ recognizer : UISwipeGestureRecognizer)

    func performDraw3Cards () {
        game.dealThreeCards()
        updateViewFromModel()
    } // performDraw3Cards()
    
    func performTouchCard(_ cardID: Int) {
//        game.selectCard(atIndex: cardID) // grow the frame and shrink it back again
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
//            self.mainViewOutlet.cardViews[cardID].transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        } )
//        updateViewFromModel()
    } // performTouchCards(_ cardID: Int)

    func performStartNewGame() {
        game.startNewGame()
        updateViewFromModel()
    } // performStartNewGame()
    
    @objc func performCardShuffle(_ recognizer : UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shuffleDrawnCards()
            updateViewFromModel()
        default:
            break
        }
    } // performCardShuffle(_ recognizer: UIRotationGestureRecognizer
    
    func getAttributesFromCardID(_ cardID: Int) -> (aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor) {
        return game.getAttributesFromCardID(cardID: cardID)
    } //getAttributesFromCardID(_ cardID: Int) -> ...
    
    func isSelectedCard(_ cardID: Int) -> Bool {
        return game.selectedCards.contains(game.drawnCards[cardID])
    } //isSeclectedCard(_ cardID: Int) -> Bool

    func isMatchedCard(_ cardID: Int) -> Bool {
        return game.matchedCards.contains(game.drawnCards[cardID])
    } //isMatchedCard(_ cardID: Int) -> Bool

    func getScore() -> Int {
        return game.score
    } //getScore() -> Int
    
    func getDrawCardsAbility() -> Bool {  // can we draw more cards?
        return game.moreCardsToDeal()
    } //getDrawCardsAbility() -> Bool
    
    func updateViewFromModel() {  // i think this needs to be smarter....
        mainViewOutlet.setNeedsLayout()
        mainViewOutlet.setNeedsDisplay()
    } //updateViewFromModel()
    
    func getTopOfDiscardPile() -> (aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor)? {
        return game.getAttributesForTopOfDiscardPile()
    }
    
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
