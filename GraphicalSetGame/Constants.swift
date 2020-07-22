//
//  Constants.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/21/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let stdFrameZoom: CGFloat = 0.95
    static let cardAspectRatio: CGFloat = 0.4572 // (93.5/204.5)
    static let boardHeightToBoundsRatio: CGFloat = 0.75
    static let pipSizeRatio: CGFloat = 0.25
    static let stripedPipLineSpacingRatio: CGFloat = 0.07
    static let cornerRadiusToBoundsHeight: CGFloat = 0.06

    static let fadeDuration: Double = 0.5
    static let cardMoveDuration: Double = 0.6
    static let cardFlipDuration: Double = 0.5
    static let animationDelay: Double = 0
    static let elasticity: CGFloat = 1.0
    static let resistance: CGFloat = 0.0
    static let bounceDuration: Double = 1.0
    static let snapDamping: CGFloat = 0.5
    static let moveToDiscardDuration: Double = 0.6
    static let moveToDiscardDelay: Double = 0.1
    
    static let startingBoardSize: Int = 12
    static let selectCardPoints: Int = 1
    static let failedMatchPoints: Int = 2
    static let goodMatchPoints: Int = 5
    
    static let cardBackOuterRingScale: CGFloat = 0.95
    static let cardBackMiddleRingScale: CGFloat = 0.75
    static let cardBackInnerRingScale: CGFloat = 0.50

    static let buttonFontSize: CGFloat = 30.0

    static let cardBackgroundColor = UIColor.lightGray
    static let boardBackgroundColor = UIColor.black
    static let borderColor = UIColor.purple
    static let buttonFontColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    static let blueCardColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    static let redCardColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    static let greenCardColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
}

extension SetGame {
    static let easyMode = false
}

extension SetCardView {
    var cornerRadius: CGFloat {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    var borderShadingLineWidth: CGFloat {
        return bounds.height * 0.025
    }
    var stripedPipLineWidth: CGFloat {
        return bounds.height * 0.01
    }    
    var highlightedCardBorderWidth: CGFloat {
        return bounds.height * 0.075
    }
} //SetCardView Computed properties

extension SetGameViewController {
    var boardBoundry: CGFloat {
        return mainViewOutlet.bounds.size.height * Constants.boardHeightToBoundsRatio
    }
} //SetGameViewController Conputed properties

