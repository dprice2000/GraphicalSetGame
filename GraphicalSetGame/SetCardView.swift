//
//  SetCardView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

// draw one card

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }

    private var cardViewIdentifier: Int? = nil
    private var cardColor: UIColor? = nil
    private var pipCount: Int? = nil
    private var shape: SetCard.Shape? = nil
    private var shading: SetCard.Shading? = nil
    
    func initSetCardViewAttributes(cardViewID: Int) {
        cardViewIdentifier = cardViewID
        if let aSGVC = findViewController()  as? SetGameViewController {
            let cardAttributes = aSGVC.getAttributesFromCardID(cardID: cardViewID)
            
            shape = cardAttributes.myShape
            shading = cardAttributes.myShading
            
            switch cardAttributes.myPipCount {
                case SetCard.PipCount.one: pipCount = 1
                case SetCard.PipCount.two: pipCount = 2
                case SetCard.PipCount.three: pipCount = 3
            }
        
            switch cardAttributes.myCardColor {
                case SetCard.CardColor.first: cardColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case SetCard.CardColor.second: cardColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                case SetCard.CardColor.third: cardColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }
        }
    }
    
    private func buildSinglePip(_ pipBounds: CGRect) -> UIBezierPath {
        let centerPoint = CGPoint(x: pipBounds.width/2.0, y: pipBounds.height/2.0 + pipBounds.origin.y) // if you don't move to pipBounds.origin, all of the pips drawn on top of eachother
        let shapeSize = pipBounds.width/3.0
        var path: UIBezierPath
        let unWrappedShape = shape!
        
        switch unWrappedShape {
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
    }
    
    private func buildPipInformation() -> [UIBezierPath] {
        var paths = [UIBezierPath()]
        
        switch pipCount! {
        case 1:
            paths.append(buildSinglePip(bounds))
        case 2:
            let (topFrame, bottomFrame) = bounds.divided(atDistance: bounds.size.height * 0.50, from: CGRectEdge.minYEdge)
//            print("top frame \(topFrame) and bottom frame \(bottomFrame)")
            paths.append(buildSinglePip(topFrame))
            paths.append(buildSinglePip(bottomFrame))

        case 3:
            let (topFrame, remainingFrame) = bounds.divided(atDistance: bounds.size.height * 0.33, from: CGRectEdge.minYEdge)
            let (middleFrame, bottomFrame) = remainingFrame.divided(atDistance: remainingFrame.size.height * 0.50, from: CGRectEdge.minYEdge)
            paths.append(buildSinglePip(topFrame))
            paths.append(buildSinglePip(middleFrame))
            paths.append(buildSinglePip(bottomFrame))
        default:
            break
        }
        return paths
    }
    
    override func draw(_ rect: CGRect) {
        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.orange.setFill()
        cardBackground.fill()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.lightGray.setFill()
        roundedRect.fill()

        let paths = buildPipInformation()
        cardColor?.setFill()

        for path in paths {
            path.fill()
        }
        let myCardButton = UIButton(type: .custom)
        let myCardButtonCustomView = UIView(frame: bounds)
        myCardButtonCustomView.isUserInteractionEnabled = false
        myCardButton.frame = bounds
        myCardButton.addSubview(myCardButtonCustomView)
        myCardButton.addTarget(self, action: #selector(touchCardAction), for: .touchUpInside)
        addSubview(myCardButton)
        // Drawing code
    }
    
    @objc
    func touchCardAction() {
        print("Touched a card! \(cardViewIdentifier!)")
    }
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}

//extension SetCardView {
//    private struct keyPoints {
//        static let centerPoint = CGPoint(x: bounds.height/2.0, y: bounds.width/2.0)
//    }
//
//}

