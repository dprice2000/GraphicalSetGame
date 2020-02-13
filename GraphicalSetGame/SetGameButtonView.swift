//
//  SetGameButtonView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

// if I'm in portrait mode, stack my buttons
// if I'm in landscape mode, my buttons are side by side

import UIKit

@IBDesignable
class SetGameButtonView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.green.setFill()
        boardBackground.fill()

    }

}
