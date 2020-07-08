//
//  DrawDeckView.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/7/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

class DrawDeckView: UIView {
    
    var isEnabled: Bool?

    override func draw(_ rect: CGRect) {
        let backgroundRect = UIBezierPath(rect: rect)
        UIColor.clear.setFill()
//        SetGameViewController.boardBackgroundColor.setFill()
        backgroundRect.fill()
        if ( isEnabled == true) {
            SetCardView.drawCardBack(rect)
        } else {
            let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.95), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
            SetGameViewController.buttonFontColor.setStroke()
            outterRoundedRect.stroke()
        }
    }

}
