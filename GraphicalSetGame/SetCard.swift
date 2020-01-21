//
//  SetCard.swift
//  
//
//  Created by Dave on 1/21/20.
//

import Foundation


struct SetCard: CustomStringConvertible, Equatable {
    var description: String { return "\(shading) \(shape) \(pipCount) \(cardColor)" }
    
    private(set) var shape : Shape
    private(set) var shading : Shading
    private(set) var pipCount : PipCount
    private(set) var cardColor : CardColor
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        if rhs.cardColor != lhs.cardColor { return false }
        if rhs.pipCount != lhs.pipCount { return false }
        if rhs.shading != lhs.shading { return false }
        if rhs.shape != lhs.shape { return false }
        return true
    }
    enum Shading: String, CustomStringConvertible  {
        var description: String {
            switch self {
            case Shading.border: return "border"
            case Shading.shaded: return "shaded"
            case Shading.filled: return "filled"
            }
        } // description
        
        case border = "border"
        case shaded = "shaded"
        case filled = "filled"
        
        static var all = [Shading.border, .shaded, .filled]
    } // Shading
    
    enum Shape: String, CustomStringConvertible  {
        var description: String {
            switch self {
            case Shape.first: return "triangle"
            case Shape.second:   return "circle  "
            case Shape.third:   return "square  "
            }
        } // description
        
        case first = "first"
        case third = "second"
        case second = "third"
        
        static var all = [Shape.first, .third, .second]
    } // Shape
    
    enum PipCount: Int, CustomStringConvertible  {
        var description: String {
            switch self {
            case PipCount.one:   return "one  "
            case PipCount.two:   return "two  "
            case PipCount.three: return "three"
            }
        } // description
        
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [PipCount.one, .two, .three]
    } // PipCount
    
    enum CardColor: String, CustomStringConvertible  {
        var description: String {
            switch self {
            case CardColor.first:   return "red  "
            case CardColor.second: return "green"
            case CardColor.third:  return "blue "
            }
        } // description
        
        case first = "first"
        case second = "second"
        case third = "third"
        
        static var all = [CardColor.first, .second, .third]
    } // CardColor
    
    // this getter is for the view
    func getCardAttributes() -> (myShape: SetCard.Shape, myShading: SetCard.Shading, myPipCount: SetCard.PipCount, myCardColor: SetCard.CardColor) {
        return (self.shape, self.shading, self.pipCount, self.cardColor)
    } // getCardAttributes()
    
    init (shape: SetCard.Shape, shading: SetCard.Shading, pipCount: SetCard.PipCount, cardColor: SetCard.CardColor) {
        self.shape = shape
        self.shading = shading
        self.pipCount = pipCount
        self.cardColor = cardColor
    } // init(shape: Card.Shape, shading: Card.Shading, pipCount: Card.PipCount, Card.CardColor)
    
} // Card
