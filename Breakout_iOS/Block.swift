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
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, x: Double, y: Double) {
        super.init(texture: texture, color: color, size: size)
        
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody()
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
