//
//  BreakoutItem.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation

public enum ItemType {
    case speedUp
    case speedDown
    case newBall
    case plateShrink
    case plateEnlarge
    case ballShrink
    case ballEnlarge
    
    static func randomValue() -> ItemType {
        let values: [ItemType] = [.speedUp, .speedDown, .newBall, .plateShrink, .plateEnlarge, .ballShrink, .ballEnlarge]
        let index = Int(arc4random_uniform(UInt32(values.count)))
        let value = values[index]
        return value
    }
}

class BreakoutItem {
    
    
    
    let type: ItemType
    let containingBlock: Block
    
    init(type: ItemType, containingBlock: Block) {
        self.type = type
        self.containingBlock = containingBlock
    }
    
}
