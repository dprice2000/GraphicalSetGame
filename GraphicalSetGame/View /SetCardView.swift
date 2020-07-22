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

    // init with a frame and card attributes
    init(frame: CGRect, cardAttributes:(aShape: SetCard.Shape, aShading: SetCard.Shading, aPipCount: SetCard.PipCount, aCardColor: SetCard.CardColor)) {
        
        shape = cardAttributes.aShape
        shading = cardAttributes.aShading
        
        switch cardAttributes.aPipCount {
        case SetCard.PipCount.one: pipCount = 1
        case SetCard.PipCount.two: pipCount = 2
        case SetCard.PipCount.three: pipCount = 3
        }
        
        switch cardAttributes.aCardColor {
        case SetCard.CardColor.first: cardColor = Constants.blueCardColor
        case SetCard.CardColor.second: cardColor = Constants.redCardColor
        case SetCard.CardColor.third: cardColor = Constants.greenCardColor
        }
        super.init(frame: frame)
        layer.masksToBounds = true

    } // init (frame: CGRect, cardViewID: Int, cardAttributes: ...
    
    private(set) var cardColor: UIColor
    private(set) var pipCount: Int
    private(set) var shape: SetCard.Shape
    private(set) var shading: SetCard.Shading

    var isFaceUp = false { didSet { setNeedsDisplay() } }  // if you flip the card, you need to draw it again.
    var isSelected = false {
        // when the selected state toggles, fade in or out the card border
        didSet {
            UIView.transition(with: self, duration: Constants.fadeDuration, options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.setNeedsDisplay()
            })
        }
    } // isSelected

    // return the a UIBezierPath that represents a single pip for the view, based on the shape
    private func buildSinglePip(_ pipBounds: CGRect) -> UIBezierPath {
        let centerPoint = CGPoint(x: pipBounds.width/2.0, y: pipBounds.height/2.0 + pipBounds.origin.y)
                                // if you don't move to pipBounds.origin.y, all of the pips draw on top of eachother
        let shapeSize = pipBounds.width * Constants.pipSizeRatio
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
    
    // build a path to draw all of the pips on the card, based on the pipCount
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

    // draw concentric ellipses in each of the card colors to represent the back of a card
    // made this function available as a class function so that the DrawDeckView can reuse the
    // code
    class func drawCardBack(_ rect: CGRect) { 
        let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: Constants.cardBackOuterRingScale), cornerRadius: rect.size.height * Constants.cornerRadiusToBoundsHeight)
        Constants.greenCardColor.setFill()
        outterRoundedRect.fill()
        let midRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: Constants.cardBackMiddleRingScale), cornerRadius: rect.size.height * Constants.cornerRadiusToBoundsHeight)
        Constants.redCardColor.setFill()
        midRoundedRect.fill()
        let innerRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: Constants.cardBackInnerRingScale), cornerRadius: rect.size.height * Constants.cornerRadiusToBoundsHeight)
        Constants.blueCardColor.setFill()
        innerRoundedRect.fill()
    } // drawCardBack()
    
    // render the view for the card.
    override func draw(_ rect: CGRect) {
        // resize the corner radius each time the card is drawn.  As more cards
        // are added to the board, they get smaller.  Corner radius needs to be
        // recalculated.
        layer.cornerRadius = cornerRadius

        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.clear.setFill()
        cardBackground.fill()
        
        // if we are not face up, just draw the card back and return.
        if isFaceUp == false {
            SetCardView.drawCardBack(rect)
            return
        }
        
        // fill in the background color of the card
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        Constants.cardBackgroundColor.setFill()
        roundedRect.fill()

        // if we are selected, draw a border around the card
        if isSelected == true {
            Constants.borderColor.setStroke()
            roundedRect.lineWidth = highlightedCardBorderWidth
            roundedRect.stroke()
        }
         
        // build the path for the pips
        let drawingPipsPath = buildPipInformation()

        // add the shading element to the path and draw it
        switch shading {
        case SetCard.Shading.filled:
            cardColor.setFill()
            drawingPipsPath.fill()
        case SetCard.Shading.border:
            cardColor.setStroke()
            drawingPipsPath.lineWidth = borderShadingLineWidth
            drawingPipsPath.stroke()
        case SetCard.Shading.shaded:
            cardColor.setStroke()
            drawingPipsPath.stroke()
            drawingPipsPath.addClip()
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = stripedPipLineWidth
            
            var currentX:CGFloat = 0.0
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: bounds.size.height))
                currentX += Constants.stripedPipLineSpacingRatio * bounds.size.width
            }
            stripedPath.stroke()
        }
        
    } //draw()
    
} // SetCardView

