//
//  DrawDeckView.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/7/20.
//  Copyright © 2020 Dave. All rights reserved.
//
//
// simple view to draw a card back or a slim border if the draw deck is empty

import UIKit

class DrawDeckView: UIView {
    
    var isEnabled = true { didSet { setNeedsDisplay() } }  // if our status toggles, redraw us
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // give the view rounded corners
        layer.cornerRadius = bounds.height * Constants.cornerRadiusToBoundsHeight
        layer.masksToBounds = true
    } // init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } // init
    
    override func draw(_ rect: CGRect) {
        let backgroundRect = UIBezierPath(rect: rect)
        UIColor.clear.setFill()
        backgroundRect.fill()
        if ( isEnabled == true) {
            SetCardView.drawCardBack(rect)
        } else {
            let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: Constants.stdFrameZoom), cornerRadius: rect.size.height * Constants.cornerRadiusToBoundsHeight)
            Constants.buttonFontColor.setStroke()
            outterRoundedRect.stroke()
        }
    } // draw

} // DrawDeckView
