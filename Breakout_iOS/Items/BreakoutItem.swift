//
//  BreakoutItem.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import Foundation

public enum ItemType: String {
    case speedUp
    case speedDown
    case newBall
    case plateShrink
    case plateEnlarge
    case ballShrink
    case ballEnlarge
    case none
    
    static func randomValue() -> ItemType {
        let values: [ItemType] = [.speedUp, .speedDown, .newBall, .plateShrink, .plateEnlarge, .ballShrink, .ballEnlarge]
        let index = Int(arc4random_uniform(UInt32(values.count)))
        let value = values[index]
        return value
    }
    static func color(type: ItemType) -> UIColor {
        switch type {
        case .newBall, .ballEnlarge, .plateEnlarge, .speedDown:
            return UIColor.green
        case .ballShrink, .plateShrink, .speedUp:
            return UIColor.red
        default: break
        }
        return UIColor.purple
    }
}

class BreakoutItem: SKSpriteNode {
    
    let type: ItemType
    let containingBlock: Block
    let game: GameScene
    
    init(type: ItemType, containingBlock: Block, game: GameScene, color: UIColor) {
        self.type = type
        self.containingBlock = containingBlock
        self.game = game
        let size = CGSize(width: 10, height: 10)
        super.init(texture: nil, color: ItemType.color(type: type), size: size)
        self.name = "item"//String(self.type.rawValue)
        self.position = containingBlock.position
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: true, setRestitutionTo: 1)//, affectedByGravity: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        print("activate")
    }
    
}
