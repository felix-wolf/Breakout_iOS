//
//  GameScene.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 30.05.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let ballCategory: UInt32 = 0x1 << 0
    let bottomCategory: UInt32 = 0x1 << 1
    let blockCategory: UInt32 = 0x1 << 2
    let plateCategory: UInt32 = 0x1 << 3
    
    let amountOfBlocksPerRow = 6
    let amountOfBlocksPerCollumn = 4
    var mainBall = SKShapeNode()
    var fingerOnPlate = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 3
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: false, setRestitutionTo: 1)
        
        Utils.shared.setUpXCoordinates(amountOfBlocksPerCollumn: amountOfBlocksPerCollumn, amountOfBlocksPerRow: amountOfBlocksPerRow)
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            for index in 0..<amountOfBlocksPerRow {
                let node = Utils.shared.createBlock(index: index, outerIndex: outerIndex)
                self.addChild(node)
            }
        }
        
        let mainBall = Ball(radius: 10, name: "ball")
        addChild(mainBall)
        mainBall.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
        
        let plate = Block(texture: nil, color: UIColor.yellow, size: CGSize(width: 100, height: 20), x: Int(UIScreen.main.bounds.width) / 2, y: 40, name: "plate")
        plate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(UIScreen.main.bounds.width), height: 16))
        addChild(plate)
        Utils.shared.setUpPhysicsbody(body: plate.physicsBody, isDynamic: false, setRestitutionTo: 1)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "block" {
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.collisionBitMask == 1 || contact.bodyA.collisionBitMask == 1 {
            print("Frame hit")
        }
        if contact.bodyA.node?.name == "plate" {
            print("plate hit")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node?.name == "plate" {
                fingerOnPlate = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerOnPlate {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            let plate = childNode(withName: "plate") as! SKSpriteNode
            var plateX = plate.position.x + (touchLocation.x - previousLocation.x)
            plateX = max(plateX, plate.size.width/2)
            plateX = min(plateX, size.width - plate.size.width / 2)
            plate.position = CGPoint(x: plateX, y: plate.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerOnPlate = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
