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
    private(set) var score: Int
    private var startingBoardSize: Int

    // create a new game.  Draw the initial cards into play.
    init(boardSize: Int) {
        startingBoardSize = boardSize
        score = 0
        for _ in 1...startingBoardSize {
            if let aCard = gameDeck.drawOneCard() {
                drawnCards.append(aCard)
            }
        }
    } // init()
    
    //  Do we have more cards to deal?
    func moreCardsToDeal() -> Bool {
        return gameDeck.cards.count > 0 
    } // moreCardsToDeal() -> Bool
  
    // remove the matched cards from the drawn cards array, replace the
    // card in that location with a new card.  If we can't draw another card
    // the game deck is empty.  In that case, the drawnCard array gets smaller
    // finally empty out the matched cards array
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
  
    // suffle the drawn cards
    mutating func shuffleDrawnCards() {
        drawnCards.shuffle()
    } // shuffleDrawnCards()
    
    // if we have a match, we want to replace them with new cards.
    // if we don't have a match, then we are adding three cards to the end of the drawnCards array.
    // the penalty for adding more cards to the drawn cards array is 2 points.
    mutating func dealThreeCards() {
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
    
    
    // In the set game, each card attribute must either be the same on all cards, or different on all cards.
    // In other words, you cannot have one attribute on only two cards.  One card with squares, one with
    // triangles and one with circles does not break the set. Two cards with triangles and one with squares breaks the
    // set.  Three cards with triangles does not break the set.
    // So if the count of any attribute is 2, return false.
    private func isSelectionASet () -> Bool  {
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
            score+=Constants.selectCardPoints
            return
        }

        // unselect previously selected card
        if selectedCards.contains(drawnCards[atIndex]) == true {
            selectedCards.remove(at: selectedCards.firstIndex(of: drawnCards[atIndex])!)
            score-=Constants.selectCardPoints
            return
        }
        
        // add the card to selected cards, then check for a match
        // if we do match, fill the matched cards array and empty
        // the selected cards array
        score+=Constants.selectCardPoints
        selectedCards.append(drawnCards[atIndex])
        if selectedCards.count == 3 {
            if isSelectionASet() == true {
                score -= Constants.goodMatchPoints // remove 5 points, 1 for each selected card and 2 more for making the set
            // move the selected cards into the marched cards list
            for index in selectedCards.indices {
                matchedCards.append(selectedCards[index])
            }
            selectedCards.removeAll()
            } else {
                score += Constants.failedMatchPoints  // failed to make a set, +2 points.  So that's 1 point per selected card and 2 points for the failed set, so + 5 points on a failed set.
            }
        }
    } // selectCard (atIndex: Int)
    
    // starting a new game means clearing out the drawn cards, matched cards and selected cards
    // then resetting the score and making a new deck and drawing the initial cards
    mutating func startNewGame()
    {
        drawnCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        score = 0
        gameDeck = SetDeck() // make a new deck
        for _ in 1...startingBoardSize {
            if let aCard = gameDeck.drawOneCard() {
                drawnCards.append(aCard)
            }
        }
    } // startNewGame()
    
    // return a tupple representing the attributes for the card in the drawnCards array
    func getAttributesFromCardID(cardID: Int) -> (aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor) {
        assert(cardID < drawnCards.count, "Invalid cardID in getAttributesForCardID")
        return drawnCards[cardID].getCardAttributes()   
    } // getAttributesFromCardID()
     
    // return true of the card at index in drawnCards is also in the selectedCards array
    func isCardSelected(_ index: Int) -> Bool {
        assert(index < drawnCards.count, "Invalid index in isCardSelected")
        return selectedCards.contains(drawnCards[index])
    } // isCardSelected()
    
    // return true of the card at index in drawnCards is also in the matchedCards array
    func isCardMatched(_ index: Int) -> Bool {
        assert(index < drawnCards.count, "Invalid index in isCardMatched")
        return matchedCards.contains(drawnCards[index])
    } // isCardMatched()
    
} // SetGame()

