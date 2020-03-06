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
    }

    func getBoardSize() -> Int {
        return game.drawnCards.count
    }
    
    @objc func performDraw3Cards(_ recognizer : UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shuffleDrawnCards()
        default:
            break
        }
        updateViewFromModel()
    }

    func performDraw3Cards () {
        game.dealThreeCards()
        print("number of cards = \(getBoardSize())")
    }
    
    func performTouchCard(_ cardID: Int) {
        game.selectCard(atIndex: cardID)
        updateViewFromModel()
    }

    func performStartNewGame() {
        game.startNewGame()
        updateViewFromModel()
    }
    
    @objc func performCardShuffle(_ recognizer : UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.shuffleDrawnCards()
        default:
            break
        }
        updateViewFromModel()
    }
    
    func getAttributesFromCardID(_ cardID: Int) -> (myShape: SetCard.Shape, myShading: SetCard.Shading, myPipCount: SetCard.PipCount, myCardColor: SetCard.CardColor) {
        return game.getAttributesFromCardID(cardID: cardID)
    }
    
    func isSelectedCard(_ cardID: Int) -> Bool {
        return game.selectedCards.contains(game.drawnCards[cardID])
    }

    func isMatchedCard(_ cardID: Int) -> Bool {
        return game.matchedCards.contains(game.drawnCards[cardID])
    }

    func getScore() -> Int {
        return game.score
    }
    
    func updateViewFromModel() {
        mainViewOutlet.setNeedsLayout()
        mainViewOutlet.setNeedsDisplay()
    }
    
}

