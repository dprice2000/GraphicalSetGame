//
//  SetCardView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

// draw (paint) one card

import UIKit

@IBDesignable
class SetCardView: UIView {

    override init(frame: CGRect) { fatalError("init(frame:) has not been implemented") }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(frame: CGRect, cardAttributes:(aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor)) {
        
        shape = cardAttributes.aShape
        shading = cardAttributes.aShading
        
        switch cardAttributes.aPipCount {
        case SetCard.PipCount.one: pipCount = 1
        case SetCard.PipCount.two: pipCount = 2
        case SetCard.PipCount.three: pipCount = 3
        }
        
        switch cardAttributes.aCardColor {
        case SetCard.CardColor.first: cardColor = SetCardView.blueCardColor
        case SetCard.CardColor.second: cardColor = SetCardView.redCardColor
        case SetCard.CardColor.third: cardColor = SetCardView.greenCardColor
        }
        super.init(frame: frame)
    } // init (frame: CGRect, cardViewID: Int, cardAttributes: ...
    
    var cardColor: UIColor
    var pipCount: Int
    var shape: SetCard.Shape
    var shading: SetCard.Shading

    var isFaceUp = false { didSet { setNeedsDisplay() } }  // if you flip the card, you need to draw it again.
    var isSelected = false {
        didSet {
//            setNeedsDisplay()
            UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve,
                              animations: {
                                self.setNeedsDisplay()
            })
        } }  // if you select the card, you need to draw it again.

    private func buildSinglePip(_ pipBounds: CGRect) -> UIBezierPath {
        let centerPoint = CGPoint(x: pipBounds.width/2.0, y: pipBounds.height/2.0 + pipBounds.origin.y)
                                // if you don't move to pipBounds.origin.y, all of the pips draw on top of eachother
        let shapeSize = pipBounds.width * SetCardView.pipSizeRatio
        var path: UIBezierPath
        
        switch shape {
        case SetCard.Shape.first: // circle
            path = UIBezierPath(arcCenter: centerPoint, radius: shapeSize, startAngle: CGFloat(0), endAngle:CGFloat.pi * 2, clockwise: true)
            
        case SetCard.Shape.second: // square
            let topCorner = CGPoint(x: centerPoint.x - shapeSize,
                                    y: centerPoint.y - shapeSize)
            path = UIBezierPath(rect: CGRect(origin: topCorner,
                                             size: CGSize(width: shapeSize*2 , height: shapeSize*2 )))

        case SetCard.Shape.third: // triangle
            path = UIBezierPath()
            path.move(to: CGPoint(x: (centerPoint.x),
                                  y: (centerPoint.y - shapeSize)))
            path.addLine(to: CGPoint(x: (centerPoint.x + shapeSize),
                                     y: (centerPoint.y + shapeSize)))
            path.addLine(to: CGPoint(x: (centerPoint.x - shapeSize),
                                     y: (centerPoint.y + shapeSize)))
            path.close()
        }
        return path
    } // buildSinglePip(_ pipBounds: CGRect) -> UIBezzierPath
    
    private func buildPipInformation() -> UIBezierPath {
        let drawingPath = UIBezierPath()
        
        switch pipCount {
        case 1:
            drawingPath.append(buildSinglePip(bounds))
        case 2:
            let (topFrame, bottomFrame) = bounds.divided(atDistance: bounds.size.height * 0.50, from: CGRectEdge.minYEdge)
            drawingPath.append(buildSinglePip(topFrame))
            drawingPath.append(buildSinglePip(bottomFrame))

        case 3:
            let (topFrame, remainingFrame) = bounds.divided(atDistance: bounds.size.height * 0.33, from: CGRectEdge.minYEdge)
            let (middleFrame, bottomFrame) = remainingFrame.divided(atDistance: remainingFrame.size.height * 0.50, from: CGRectEdge.minYEdge)
            drawingPath.append(buildSinglePip(topFrame))
            drawingPath.append(buildSinglePip(middleFrame))
            drawingPath.append(buildSinglePip(bottomFrame))
        default:
            break
        }
        return drawingPath
    } // buildPipInformaion() -> UIBezzierPath

    class func drawCardBack(_ rect: CGRect) { 
        let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.95), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.greenCardColor.setFill()
        outterRoundedRect.fill()
        let midRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.75), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.redCardColor.setFill()
        midRoundedRect.fill()
        let innerRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.50), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
        SetCardView.blueCardColor.setFill()
        innerRoundedRect.fill()
    }
    
    override func draw(_ rect: CGRect) {
        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.clear.setFill()
        cardBackground.fill()
        if isFaceUp == false {
            SetCardView.drawCardBack(rect)
            return
        }
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.lightGray.setFill()  // move to constants
        roundedRect.fill()

        if isSelected == true {
            UIColor.purple.setStroke()
            roundedRect.lineWidth = SetCardView.highlightedCardBorderWidth
            roundedRect.stroke()
        }
         
        let drawingPipsPath = buildPipInformation()

        switch shading {
        case SetCard.Shading.filled:
            cardColor.setFill()
            drawingPipsPath.fill()
        case SetCard.Shading.border:
            cardColor.setStroke()
            drawingPipsPath.lineWidth = SetCardView.borderShadingLineWidth
            drawingPipsPath.stroke()
        case SetCard.Shading.shaded:
            cardColor.setStroke()
            drawingPipsPath.stroke()
            drawingPipsPath.addClip()
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = SetCardView.stripedPipLineWidth  // gotta scale this for edge case of 81 cards drawn
            
            var currentX:CGFloat = 0.0
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: bounds.size.height))
                currentX += SetCardView.stripedPipLineSpacingRatio * bounds.size.width
            }
            stripedPath.stroke()
        }
        
    } //draw()
    
} // SetCardView

extension SetCardView {
    static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    private var cornerRadius : CGFloat {
        return bounds.size.height * SetCardView.cornerRadiusToBoundsHeight
    }
    static private let borderShadingLineWidth : CGFloat = 5.0
    static private let pipSizeRatio : CGFloat = 0.25
    static private let stripedPipLineWidth : CGFloat = 2.0
    static private let stripedPipLineSpacingRatio : CGFloat = 0.07
    
    static let highlightedCardBorderWidth : CGFloat = 15.0
    static let blueCardColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    static let redCardColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    static let greenCardColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
} //SetCardView constants
