//
//  BounceBehavior.swift
//  GraphicalSetGame
//
//  Created by David Price on 7/15/20.
//  Copyright © 2020 Dave. All rights reserved.
//
// all of our dynamic behaviors in one handy spot
// push in a random direction
// rotate
// bounce off of eachother
// add all of these items into one object and provide a cleanup method when we are done

import UIKit

class BounceBehavior: UIDynamicBehavior {
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    } // init
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    } // convenience init to add us to the animator
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }() // collisionBehavior
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = Constants.elasticity
        behavior.resistance = Constants.resistance
        return behavior
    }() // itemBehavior
    
    private func addRandomPushBehavior(item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = 8
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    } // pushBehavior
    
    // add the view (a dynamic item) to all of the behaviors
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        addRandomPushBehavior(item: item)
    } // addItem
    
    // remove the view from the behaviors
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    } // removeItem
}

