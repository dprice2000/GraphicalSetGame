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
        SetGameViewController.boardBackgroundColor.setFill()
        backgroundRect.fill()
        if ( isEnabled == true) {
            let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.95), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
            SetCardView.greenCardColor.setFill()
            outterRoundedRect.fill()
            let midRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.75), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
            SetCardView.redCardColor.setFill()
            midRoundedRect.fill()
            let innerRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.50), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
            SetCardView.blueCardColor.setFill()
            innerRoundedRect.fill()
        } else {
            let outterRoundedRect = UIBezierPath(roundedRect: rect.zoom(by: 0.95), cornerRadius: rect.size.height * SetCardView.cornerRadiusToBoundsHeight)
            SetGameViewController.buttonFontColor.setStroke()
            outterRoundedRect.stroke()
        }
    }

}
