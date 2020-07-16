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
    
    mutating func drawOneCard() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at:cards.count.arc4random)
        }
        return nil
    } // draw() -> Card?
} // SetDeck


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    } // arc4random()
}  // extension

