//
//  ViewController.swift
//  GraphicalSetGame
//
//  Created by Dave on 1/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//


import UIKit

class SetGameViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var mainViewOutlet: UIView!

    private var font = UIFont.preferredFont(forTextStyle: .body).withSize(Constants.buttonFontSize)
    private lazy var attributes:[NSAttributedString.Key:Any] = [
        .foregroundColor: Constants.buttonFontColor,
        .backgroundColor: Constants.cardBackgroundColor,
        .font:font
    ]
    
    private lazy var game = SetGame(boardSize: Constants.startingBoardSize)

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
    private var animator: UIDynamicAnimator!
    private var bounceBehavior: BounceBehavior!
    private var bouncingCards = [SetCardView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewOutlet.backgroundColor = Constants.boardBackgroundColor
        
        // split the view for the card board and the button area
        let (setGameBoardFrame, setGameButtonFrame) = mainViewOutlet.bounds.divided(atDistance: boardBoundry, from: CGRectEdge.minYEdge)
        setGameBoardView = SetGameBoardView(frame: setGameBoardFrame)
        mainViewOutlet.addSubview(setGameBoardView)
        
        var drawDeckButtonFrame : CGRect
        var newGameButtonFrame : CGRect
        var scoreLabelFrame : CGRect
        var remainingFrame : CGRect
        
        // define the frame for the draw deck, discard pile, new game button and score label
        (drawDeckButtonFrame, remainingFrame) =
            setGameButtonFrame.divided(atDistance: setGameButtonFrame.size.height * Constants.cardAspectRatio, from: CGRectEdge.minXEdge)
        (discardPileFrame, remainingFrame) =
            remainingFrame.divided(atDistance: setGameButtonFrame.size.height * Constants.cardAspectRatio, from: CGRectEdge.minXEdge)
        (newGameButtonFrame,scoreLabelFrame) =
            remainingFrame.divided(atDistance: remainingFrame.size.height * 0.50, from: CGRectEdge.minYEdge)

        // create the draw deck view, give it a tap recognizer and push behind any views that get drawn in the same space
        drawDeckView = DrawDeckView(frame: drawDeckButtonFrame)
        drawDeckView.isEnabled = game.moreCardsToDeal()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(drawDeckViewTapped(_:)))
        drawDeckView.addGestureRecognizer(recognizer)
        mainViewOutlet.addSubview(drawDeckView)
        mainViewOutlet.sendSubviewToBack(drawDeckView)
        startingCardViewFrame = drawDeckButtonFrame
        
        // create the discard pile view and push it behind any ciews that get drawn in the same space
        discardPileView = DiscardPileView(frame: discardPileFrame)
        mainViewOutlet.addSubview(discardPileView)
        mainViewOutlet.sendSubviewToBack(discardPileView)
        
        // make the new game button
        var titleAttributedString = NSAttributedString(string: "New Game", attributes: attributes)
        newGameButton = UIButton(type: .custom)
        newGameButton.frame = newGameButtonFrame.zoom(by: 0.95)
        newGameButton.layer.cornerRadius = 15
        newGameButton.layer.masksToBounds = true
        newGameButton.backgroundColor = Constants.cardBackgroundColor
        newGameButton.setAttributedTitle(titleAttributedString, for: UIControl.State.normal)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        mainViewOutlet.addSubview(newGameButton)
        
        // make the score label
        scoreLabel = UILabel()
        titleAttributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.frame = scoreLabelFrame.zoom(by: 0.95)
        scoreLabel.backgroundColor = Constants.cardBackgroundColor
        scoreLabel.attributedText = titleAttributedString
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.layer.cornerRadius = 15
        scoreLabel.layer.masksToBounds = true
        mainViewOutlet.addSubview(scoreLabel)
        
        // create the dynamic animator and bounce behavior
        animator = UIDynamicAnimator(referenceView: setGameBoardView)
        bounceBehavior = BounceBehavior(in: animator)
        animator.delegate = self
    } //viewDidLoad()
    
    override func viewDidAppear(_ animated: Bool) {
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        // build an array of all set card views to be displayed and pass it to the SetGameBoardView
        // to be displayed.
        
        var cardViews = [SetCardView]()
        
        // if the game has matched cards, move their views to the discard pile
        // have the game replace them now, so when we fill the cardViews array, new views
        // will be generated for the replacement card.
        
        if game.matchedCards.count == 3 {
            for matchedCard in game.matchedCards {
                let matchedCardView = getViewForSetCard(matchedCard)
                throwAwayMatchedCard(matchedCardView)
            }
            game.replaceMatchedCards()
            // disable the draw deck if we are out of cardw to draw
            if game.moreCardsToDeal() == false {
                drawDeckView.isEnabled = false
            }
        }

        // get the views for all of the drawn cards
        for card in game.drawnCards {
            let cardView = getViewForSetCard(card)
            cardViews.append(cardView)
        }
        
        // update the displayed score and setGameBoardView
        score = game.score
        setGameBoardView.displayedCardViews = cardViews
    } //updateViewFromModel()
    
    private func getViewForSetCard(_ card: SetCard) -> SetCardView {
        // make a card view based on the attributes of the card.
        // if a view with these attributed already exists, return the exiting view
        // otherwise finsihed setting up the new view and return it
        
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
    } // getViewForSetCard (....) -> SetCardView

    private func throwAwayMatchedCard(_ view: SetCardView) {
        // add the card to the animator
        // set a timer for the card to be bouncing
        // move the view to the discard pile
        // clean up unneeded fiews on the discard pile
        setGameBoardView.bringSubviewToFront(view)
        bounceBehavior.addItem(view)

        Timer.scheduledTimer(withTimeInterval: Constants.bounceDuration, repeats: false) { timer in
            self.bounceBehavior.removeItem(view)
            self.setGameBoardView.bringSubviewToFront(view)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.moveToDiscardDuration,
                                                           delay: Constants.moveToDiscardDelay,
                                                           options: [.curveEaseInOut] ,
                                                                       animations: {
                                                                        view.transform = .identity
                                                                        view.frame = self.discardPileFrame.zoom(by: Constants.stdFrameZoom)
                                                                        self.addSnapBehavior(item: view)
                                                                        view.setNeedsDisplay()
            }, completion: { finished in
                if self.discardPileView.topCardView != nil {
                    self.discardPileView.topCardView?.removeFromSuperview()
                }
                self.discardPileView.topCardView = view
                view.setNeedsDisplay()
            })
        }
    } // throwAwayMatchedCard(....)
 
    private func addSnapBehavior(item: UIDynamicItem) {
        // let the card wiggle a little when it gets to the discard pile
        let snap = UISnapBehavior(item: item, snapTo: discardPileView.center)
        snap.damping = Constants.snapDamping
        snap.action = {
            item.transform = .identity
            item.center = self.discardPileView.center
        }
        animator.addBehavior(snap)
    } // addSnapBehavior(....)
    
    @objc func cardViewTapped(_ recognizer: UITapGestureRecognizer) {
        // handle taps on the card views
        assert(game.drawnCards.count <= setGameBoardView.displayedCardViews.count, "Too many cards, not enough views.")
        
        if let cardView = recognizer.view as? SetCardView,
            let cardViewIndex = setGameBoardView.displayedCardViews.firstIndex(of: cardView) {
            game.selectCard(atIndex: cardViewIndex)
            for index in game.drawnCards.indices {
            // If 3 cards are selected and we tap a fourth card, then the selected cards are unselected
            // and the fourth card is selected.  So 4 cards can change state, we need to loop through all of
            // the views and make them show in the correct state. 
                if game.isCardSelected(index) != setGameBoardView.displayedCardViews[index].isSelected {
                    setGameBoardView.displayedCardViews[index].isSelected.toggle()
                }
            }
            if game.matchedCards.count == 3 {
                updateViewFromModel()
            }
            score = game.score
        }
    } // cardViewTapped(....)
    
    @objc func drawDeckViewTapped(_ recognizer: UITapGestureRecognizer) {
        // handle taps on the draw deck
        if game.moreCardsToDeal() == false { // nothing to do
            return
        }
        game.dealThreeCards()
        if game.moreCardsToDeal() == false {  // disable if the draw deck is empty
            drawDeckView.isEnabled = false
        }
        score = game.score
        updateViewFromModel()
    } // drawDeckTapped(....)
    
    @objc func newGameButtonTapped(_ sender: UIButton) {
        // clean up and start a new game
        setGameBoardView.resetForNewGame()
        game.startNewGame()
        updateViewFromModel()
    } // newGameButtonTapped(....)
    
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



