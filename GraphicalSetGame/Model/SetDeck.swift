//
//  SetDeck.swift
//  Set
//
//  Created by Dave on 1/2/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import Foundation

struct SetDeck
{
    private(set) var cards = [SetCard]()
    
    // the deck consists of one card for every combination of the card attributes
    init () {
        for shape in SetCard.Shape.all {
            for shading in SetCard.Shading.all {
                for pipCount in SetCard.PipCount.all {
                    for cardColor in SetCard.CardColor.all {
                        cards.append(SetCard(shape: shape, shading: shading, pipCount: pipCount, cardColor: cardColor))
                    }
                }
            }
        }
    } // init()
    
    // remove one random card from the deck and return it to the caller
    mutating func drawOneCard() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at:cards.count.arc4random)
        }
        return nil
    } // draw() -> Card?
} // SetDeck




