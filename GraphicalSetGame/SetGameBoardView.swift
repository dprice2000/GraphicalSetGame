//
//  SetGameBoardView.swift
//  GraphicalSetGame
//
//  Created by Dave on 2/12/20.
//  Copyright © 2020 Dave. All rights reserved.
//

import UIKit

@IBDesignable
class SetGameBoardView: UIView {

    private var grid = Grid(layout: Grid.Layout.aspectRatio(SetGameBoardView.cardAspectRatio))
    var numberOfCardViews: Int?
    private var cardViews = [SetCardView]()

    override func draw(_ rect: CGRect) {
        // Drawing code
        let boardBackground = UIBezierPath(rect: bounds)
        UIColor.clear.setFill()
        boardBackground.fill()
        grid.frame = bounds
        if let sgvc = findViewController()  as? SetGameViewController {
            grid.cellCount = sgvc.getBoardSize()

            for subView in subviews {
                subView.removeFromSuperview()
            }
            
            for cardViewIndex in 0 ..< grid.cellCount {
                let cardAttributes = sgvc.getAttributesFromCardID(cardViewIndex)
                let aSetCardView = SetCardView(frame: grid[cardViewIndex]!.zoom(by: 0.95),cardViewID: cardViewIndex, cardAttributes: cardAttributes)
                cardViews.append(aSetCardView)
                addSubview(aSetCardView)
            }
        }
    } // draw()

}
extension SetGameBoardView  {
    static private let cardAspectRatio : CGFloat = 0.4572 // (93.5/204.5)
} //SetGameBoardView Constants
