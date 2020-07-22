//
//  DiscardPileView.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/14/20.
//  Copyright © 2020 Dave. All rights reserved.
//
// View to draw a border representing an empty discard pile
// also hold a link to the last cardView moved here.


import UIKit

class DiscardPileView: UIView {

    var topCardView: SetCardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // round the corners of the view
        layer.cornerRadius = bounds.height * Constants.cornerRadiusToBoundsHeight
        layer.masksToBounds = true
    } // init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } // init
    
    // draw the empty pile or make certain that the topCardView is positioned properly above us
    override func draw(_ rect: CGRect) {
        let backgroundRect = UIBezierPath(rect: rect)
        UIColor.clear.setFill()
        backgroundRect.fill()
        if topCardView == nil  {
            let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: Constants.stdFrameZoom), cornerRadius: rect.size.height * Constants.cornerRadiusToBoundsHeight)
            Constants.buttonFontColor.setStroke()
            outterRoundedRect.stroke()
        } else {
            topCardView?.frame = frame.zoom(by: Constants.stdFrameZoom)
        }
    } // draw()

} // DiscardPileView
