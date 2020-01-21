//
//  SetGame.swift
//  Set
//
//  Created by Dave on 1/3/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import Foundation

struct SetGame {
    private var gameDeck = SetDeck()
    private(set) var drawnCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private var boardSize = 0
    private(set) var score = 0
    

    init(boardSize: Int) {
        for _ in 1...12 {
            if let aCard = gameDeck.draw() { drawnCards.append( aCard ) } // or throw an error?
        }
        self.boardSize = boardSize
    } // init()
    
    func moreCardsToDeal() -> Bool {
        if gameDeck.cards.count == 0 { return false }
        if matchedCards.count != 0 { return true }
        if drawnCards.count == boardSize { return false }
        return true
    }
    
    private mutating func replaceMatchedCards () {
        for index in matchedCards.indices {
            if let indexInDrawnCards = drawnCards.index(of:matchedCards[index]) {
                if let replacementCard = gameDeck.draw() {
                    drawnCards[indexInDrawnCards] = replacementCard
                } else {
                    drawnCards.remove(at: indexInDrawnCards)
                }
            }
        }
        matchedCards.removeAll()
    }
    
    mutating func dealThreeCards()
    {
        if matchedCards.count > 0 {
            replaceMatchedCards()
            return
        }
        if drawnCards.count + 3 > boardSize { return }  // do not overfill the board
        for _ in 1...3 {
            if let aCard = gameDeck.draw() { drawnCards.append(aCard) }
        }
    } // dealThreeCards()
    
    private func isSelectionASet () -> Bool  {
        
//        var shapes = [SetCard.Shape: Bool]()
//        var shadings = [SetCard.Shading: Bool]()
//        var pipCounts = [SetCard.PipCount: Bool]()
//        var cardColors = [SetCard.CardColor: Bool]()
//
//        for card in selectedCards {
//            shapes[SetCard.shape] = true
//            shadings[SetCard.shading] = true
//            pipCounts[SetCard.pipCount] = true
//            cardColors[SetCard.cardColor] = true
//        }
//        if shapes.count == 2 {
//            print("NO SET -- shapes")
//            return false
//        }
//        if shadings.count == 2 {
//            print("NO SET -- shadings")
//            return false
//        }
//        if pipCounts.count == 2 {
//            print("NO SET -- pip counts")
//            return false
//        }
//        if cardColors.count == 2 {
//            print("NO SET -- colors")
//            return false
//        }
        return true
    } // isSelectionASet () -> Bool
    
    mutating func selectCard (atIndex: Int)
    {
//        print("selecting card \(atIndex)")
        if atIndex >= drawnCards.count { return }
        
        if selectedCards.count == 3  // selecting a fourth card, clear selection and select new card only
        {
            selectedCards.removeAll()
            selectedCards.append(drawnCards[atIndex])
            score+=2
            return
        }
        
        if matchedCards.count > 0  // replace all of the matched cards with new cards and clear the matched cards list
        {
            selectedCards.append(drawnCards[atIndex])
            replaceMatchedCards()
            return
        }

        if selectedCards.contains(drawnCards[atIndex]) == true // unselect already selected card
        {
            selectedCards.remove(at: selectedCards.index(of: drawnCards[atIndex])!)
            score-=1
            return
        }
        
        score+=1
        selectedCards.append(drawnCards[atIndex])
        if selectedCards.count == 3 ,  isSelectionASet() == true
        {
            score -= 3
            // move the selected cards into the marched cards list
            for index in selectedCards.indices {
                matchedCards.append(selectedCards[index])
            }
            selectedCards.removeAll()
            print("We have a set");
        }
    } // selectCard (atIndex: Int)
    
    mutating func startNewGame()
    {
        drawnCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        score = 0
        gameDeck = SetDeck() // make a new deck
        for _ in 1...12 {
            if let aCard = gameDeck.draw() { drawnCards.append( aCard ) } 
        }
    } // startNewGame()
    
} // SetGame()
