//
//  Block.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 30.05.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import Foundation

class Block: SKSpriteNode {
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, x: Int, y: Int, name: String) {
        super.init(texture: texture, color: color, size: size)
        self.name = name
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: false, setRestitutionTo: 1)
        self.physicsBody?.contactTestBitMask = 3
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
