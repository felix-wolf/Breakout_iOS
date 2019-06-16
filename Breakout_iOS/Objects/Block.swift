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
    
    init(texture: SKTexture?, color: UIColor, width: Double, height: Double, x: Int, y: Int, name: String) {
        super.init(texture: texture, color: color, size: CGSize(width: width, height: height))
        self.name = name
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: false, setRestitutionTo: 1)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
