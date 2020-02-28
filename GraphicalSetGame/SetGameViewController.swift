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
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getBoardSize() -> Int {
        return game.drawnCards.count
    }
    
    func performDraw3Cards () {
        game.dealThreeCards()
        print("number of cards = \(getBoardSize())")
    }
    
    func incrementClickCount() -> Int {
        clickCount += 1
        return clickCount
    }
    
    func getAttributesFromCardID(cardID: Int) -> (myShape: SetCard.Shape, myShading: SetCard.Shading, myPipCount: SetCard.PipCount, myCardColor: SetCard.CardColor) {
        return game.getAttributesFromCardID(cardID: cardID)
    }

    func updateViewFromModel() {
        mainViewOutlet.setNeedsLayout()
        mainViewOutlet.setNeedsDisplay()
    }
    
}

