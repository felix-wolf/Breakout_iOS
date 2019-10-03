//
//  Ball.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 16.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import Foundation

class Ball: SKSpriteNode {
    
    //    override init() {
    //        super.init()
    //    }
    //
    //    convenience init(radius: CGFloat, name: String) {
    //        self.init(circleOfRadius: radius)
    //        self.position = CGPoint(x: Int(UIScreen.main.bounds.width) / 2, y: 50)
    //        self.fillColor = UIColor.red
    //        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
    //        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: true, setRestitutionTo: 1)
    //        self.physicsBody?.categoryBitMask = 1
    //        self.physicsBody?.collisionBitMask = 2
    //        self.physicsBody?.contactTestBitMask = 3
    //        self.name = name
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    init(texture: SKTexture?, color: UIColor, width: Double, height: Double, x: Int, y: Int, name: String) {
        super.init(texture: texture, color: color, size: CGSize(width: width, height: height))
        self.name = name
        self.position = CGPoint(x: x, y: y)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: true, setRestitutionTo: 1)
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
//        self.physicsBody?.categoryBitMask = 1
//        self.physicsBody?.collisionBitMask = 2
//        self.physicsBody?.contactTestBitMask = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
