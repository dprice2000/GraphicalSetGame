//
//  ViewController.swift
//  GraphicalSetGame
//
//  Created by Dave on 1/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {

    @IBOutlet weak var mainViewOutlet: SetGameView!
    
    private lazy var game = SetGame(boardSize: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(performCardShuffle(_ :)))
        view.addGestureRecognizer(rotateRecognizer)
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(performDraw3Cards(_ :)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    } //viewDidLoad()

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
        game.selectCard(atIndex: cardID)
        updateViewFromModel()
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

