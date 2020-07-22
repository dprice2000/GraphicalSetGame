//
//  SetCard.swift
//  
//
//  Created by Dave on 1/21/20.
//

import Foundation


struct SetCard: Equatable {
    
    private(set) var shape : Shape
    private(set) var shading : Shading
    private(set) var pipCount : PipCount
    private(set) var cardColor : CardColor
    
    // support Equatable - all attributes must be the same
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        if rhs.cardColor != lhs.cardColor { return false }
        if rhs.pipCount != lhs.pipCount { return false }
        if rhs.shading != lhs.shading { return false }
        if rhs.shape != lhs.shape { return false }
        return true
    } // ==
    
    enum Shading: String {
        case border = "border"
        case shaded = "shaded"
        case filled = "filled"
        
        static var all = [Shading.border, .shaded, .filled]
    } // Shading
    
    enum Shape: String {
        case first = "first"
        case second = "second"
        case third = "third"
        
        static var all = [Shape.first, .third, .second]
    } // Shape
    
    enum PipCount: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [PipCount.one, .two, .three]
    } // PipCount
    
    enum CardColor: String {
        case first = "first"
        case second = "second"
        case third = "third"
        
        static var all = [CardColor.first, .second, .third]
    } // CardColor
    
    // return a tuple containing the attributes for the card
    func getCardAttributes() -> (aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor) {
        return (self.shape, self.shading, self.pipCount, self.cardColor)
    } // getCardAttributes()
    
    init (shape: SetCard.Shape, shading: SetCard.Shading, pipCount: SetCard.PipCount, cardColor: SetCard.CardColor) {
        self.shape = shape
        self.shading = shading
        self.pipCount = pipCount
        self.cardColor = cardColor
    } // init(shape: Card.Shape, shading: Card.Shading, pipCount: Card.PipCount, Card.CardColor)
    
} // Card
