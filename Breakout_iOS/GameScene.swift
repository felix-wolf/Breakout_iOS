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
    
    let amountOfBlocksPerRow = 1
    let amountOfBlocksPerCollumn = 4
   
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.categoryBitMask = 2
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, pinned: true, setRestitutionTo: 1)
        
        Utils.shared.setUpXCoordinates(amountOfBlocksPerCollumn: amountOfBlocksPerCollumn, amountOfBlocksPerRow: amountOfBlocksPerRow)
        
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            for index in 0..<amountOfBlocksPerRow {
                let node = Utils.shared.createBlock(index: index, outerIndex: outerIndex)
                self.addChild(node)
            }
        }
        
        
        let mainBall = SKShapeNode(circleOfRadius: 10)
        mainBall.position = CGPoint(x: Int(UIScreen.main.bounds.width) / 2, y: 50)
        mainBall.fillColor = UIColor.red
        mainBall.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        Utils.shared.setUpPhysicsbody(body: mainBall.physicsBody, pinned: false, setRestitutionTo: 1)
        
        
        mainBall.physicsBody?.collisionBitMask = 2
        mainBall.physicsBody?.categoryBitMask = 1
        
        
        
        addChild(mainBall)
        mainBall.physicsBody?.applyImpulse(CGVector(dx: 0.5, dy: 3))
        let plate = Block(texture: nil, color: UIColor.yellow, size: CGSize(width: 100, height: 16), x: Int(UIScreen.main.bounds.width) / 2, y: 8)
        plate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(UIScreen.main.bounds.width), height: 16))
        addChild(plate)
        Utils.shared.setUpPhysicsbody(body: plate.physicsBody, pinned: true, setRestitutionTo: 1)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "block" {
            contact.bodyA.node?.removeFromParent()
        }
    }

    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
