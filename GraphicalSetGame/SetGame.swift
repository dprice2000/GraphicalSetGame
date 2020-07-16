//
//  SetGame.swift
//  Set
//
//  Created by Dave on 1/3/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import Foundation

struct SetGame {
    var gameDeck = SetDeck()
    var drawnCards = [SetCard]()
    var selectedCards = [SetCard]()
    var matchedCards = [SetCard]()
    var score = 0

    init(boardSize: Int) {
        for _ in 1...boardSize {
            if let aCard = gameDeck.drawOneCard() {
                drawnCards.append(aCard)
            }
        }
    } // init()
    
    func moreCardsToDeal() -> Bool {
        return gameDeck.cards.count > 0 
    } // moreCardsToDeal() -> Bool
    
    mutating func replaceMatchedCards () {
        for index in matchedCards.indices {
            if let indexInDrawnCards = drawnCards.firstIndex(of:matchedCards[index]) {
                if let replacementCard = gameDeck.drawOneCard() {
                    drawnCards[indexInDrawnCards] = replacementCard
                } else {
                    drawnCards.remove(at: indexInDrawnCards)
                }
            }
        }
        matchedCards.removeAll()
    } // replaceMatchingCards()
  
    mutating func shuffleDrawnCards() {
        drawnCards.shuffle()
    } // shuffleDrawnCards()
    
    mutating func dealThreeCards()
    {
        if matchedCards.count > 0 {
            replaceMatchedCards()
            return
        }
        for _ in 1...3 {
            if let aCard = gameDeck.drawOneCard() {
                drawnCards.append(aCard)
            }
        }
        score += 2 // penalty for adding more cards to the board
    } // dealThreeCards()
    
    func isSelectionASet () -> Bool  {
        /*
         In the set game, each card attribute must either be the same on all cards, or different on all cards.
         In other words, you cannot have one attribute on only two cards.  One card with squares, one with
         triangles and one with circles does not break the set. Two cards with triangles and one with squares breaks the
         set.  Three cards with triangles does not break the set.
         So if the count of any attribute is 2, return false.
         */
        
        if SetGame.easyMode == true { return true }  // for debugging purposes only! ;)
        var shapes = [SetCard.Shape: Bool]()
        var shadings = [SetCard.Shading: Bool]()
        var pipCounts = [SetCard.PipCount: Bool]()
        var cardColors = [SetCard.CardColor: Bool]()

        for card in selectedCards {
            shapes[card.shape] = true
            shadings[card.shading] = true
            pipCounts[card.pipCount] = true
            cardColors[card.cardColor] = true
        }
        if shapes.count == 2 {
            return false
        }
        if shadings.count == 2 {
            return false
        }
        if pipCounts.count == 2 {
            return false
        }
        if cardColors.count == 2 {
            return false
        }
        return true
    } // isSelectionASet () -> Bool

    // perform all actions related to selecting a card.
    mutating func selectCard (atIndex: Int)
    {
        if atIndex >= drawnCards.count { return }
        
        // replace all of the matched cards with new cards and clear the matched cards list
        if matchedCards.count > 0 {
            selectedCards.append(drawnCards[atIndex])
            replaceMatchedCards()
            return
        }
        
        // selecting a fourth card, clear selection and select new card only
        if selectedCards.count == 3  {
            selectedCards.removeAll()
            selectedCards.append(drawnCards[atIndex])
            score+=1
            return
        }

        // unselect previously selected card
        if selectedCards.contains(drawnCards[atIndex]) == true {
            selectedCards.remove(at: selectedCards.firstIndex(of: drawnCards[atIndex])!)
            score-=1
            return
        }
        
        score+=1
        selectedCards.append(drawnCards[atIndex])
        if selectedCards.count == 3 ,  isSelectionASet() == true {
            score -= 5 // remove 5 points, 1 for each selected card and 2 more for making the set
            // move the selected cards into the marched cards list
            for index in selectedCards.indices {
                matchedCards.append(selectedCards[index])
            }
            selectedCards.removeAll()
        } else {
            score += 2  // failed to make a set, +2 points.  So that's 1 point per selected card and 2 points for the failed set, so + 5 points on a failed set.
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
            if let aCard = gameDeck.drawOneCard() {
                drawnCards.append(aCard)
            }
        }
    } // startNewGame()
    
    func getAttributesFromCardID(cardID: Int) -> (aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor) {
        return drawnCards[cardID].getCardAttributes()   
    }
        
    func isCardSelected(_ index: Int) -> Bool {
        return selectedCards.contains(drawnCards[index])
    }
    
    func isCardMatched(_ index: Int) -> Bool {
        return matchedCards.contains(drawnCards[index])
    }
    
} // SetGame()

extension SetGame {
    static let easyMode = true
}
