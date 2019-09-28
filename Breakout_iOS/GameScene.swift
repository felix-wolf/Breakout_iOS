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
    let botvarCategory: UInt32 = 0x1 << 1
    let blockCategory: UInt32 = 0x1 << 2
    let plateCategory: UInt32 = 0x1 << 3
    
    let amountOfBlocksPerRow = 6
    let amountOfBlocksPerCollumn = 4
    var fingerOnPlate = false
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(game: self),
        Playing(game: self),
        GameOver(game: self)])
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.name = "frame"
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 3
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.name = "bottom"
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = "gameMessage"
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        
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
        //mainBall.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
        let plate = Block(texture: nil, color: UIColor.yellow, width: 100, height: 30, x: Int(UIScreen.main.bounds.width) / 2, y: 10, name: "plate")
        addChild(plate)
        Utils.shared.setUpPhysicsbody(body: plate.physicsBody, isDynamic: false, setRestitutionTo: 1)
        
        gameState.enter(WaitingForTap.self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "block" {
//            let ball = childNode(withName: "ball")!
//            let xVelo = ball.physicsBody!.velocity.dx
//            let yVelo = ball.physicsBody!.velocity.dy
//            ball.physicsBody?.isDynamic = false
//            ball.physicsBody?.isDynamic = true
//            ball.physicsBody?.applyImpule(dx: xVelo, dy: -yVelo)
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyA.node?.name == "bottom" {
            print("GameOver")
        }
        if contact.bodyA.node?.name == "plate" {
            let plate = childNode(withName: "plate")!
            let ball = childNode(withName: "ball")!
            ball.physicsBody?.isDynamic = false
            ball.physicsBody?.isDynamic = true
            let diff = (plate.position.x - ball.position.x) / 10
            ball.physicsBody?.applyImpulse(CGVector(dx: -diff, dy: 3))
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
        let ball = childNode(withName: "ball")!
        //TODO: Ball vom stoppen hindern
//        if (ball.physicsBody?.velocity.dy)! < CGFloat(1) {
//            if (ball.physicsBody?.velocity.dy)! < CGFloat(0) {
//                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1))
//            } else {
//                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -1))
//            }
//        }
    }
}

extension SKPhysicsBody {
    func applyImpule(dx: CGFloat, dy: CGFloat) {
        if dx + dy < 20 {
            applyImpulse(CGVector(dx: dx, dy: dy))
        } else {
            applyImpule(dx: dx * 0.9, dy: dy * 0.9)
        }
    }
}
