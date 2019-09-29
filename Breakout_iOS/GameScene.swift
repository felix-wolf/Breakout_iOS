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
    
    var xVelo: CGFloat {
        set {
            if newValue == 0 {
                guard let ball = childNode(withName: "ball") else {return}
                ball.physicsBody?.velocity.dx = xVelo
            }
        }
        get {
            guard let ball = childNode(withName: "ball") else {return 200}
            return ball.physicsBody!.velocity.dx // WAS IST DER INHALT AN DIESER STELLE?
        }
    }
    var customSpeed: CGFloat = 350
    

    let ballCategory: UInt32 = 0x1 << 0
    let bottomCategory: UInt32 = 0x1 << 1
    let blockCategory: UInt32 = 0x1 << 2
    let plateCategory: UInt32 = 0x1 << 3
    
    let amountOfBlocksPerRow = 6
    let amountOfBlocksPerCollumn = 4
    var fingerOnPlate = false
    
    override func didMove(to view: SKView) {
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.name = "frame"
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 3
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 0.1)
        let bottom = SKNode()
        bottom.name = "bottom"
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: false, setRestitutionTo: 1)
        
        Utils.shared.setUpXCoordinates(amountOfBlocksPerCollumn: amountOfBlocksPerCollumn, amountOfBlocksPerRow: amountOfBlocksPerRow)
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            for index in 0..<amountOfBlocksPerRow {
                let node = Utils.shared.createBlock(index: index, outerIndex: outerIndex)
                self.addChild(node)
            }
        }
        
        let mainBall = Ball(texture: nil, color: UIColor.red, width: 10, height: 10, x: Int(UIScreen.main.bounds.width) / 2, y: 50, name: "ball")
        addChild(mainBall)
        mainBall.physicsBody?.velocity = CGVector(dx: customSpeed / 2, dy: customSpeed / 2)
        

        let plate = Block(texture: nil, color: UIColor.yellow, width: 100, height: 30, x: Int(UIScreen.main.bounds.width) / 2, y: 10, name: "plate")
        addChild(plate)
        Utils.shared.setUpPhysicsbody(body: plate.physicsBody, isDynamic: false, setRestitutionTo: 1)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "frame" {
            guard let ball = childNode(withName: "ball") else { return }
//            let ball = childNode(withName: "ball")
            if ball.position.y > 9 && ball.position.y < frame.size.height - 8 {
                print(frame.size.height)
                print("y-Position: \(ball.position.y)")
                print("Velocity: \(ball.physicsBody!.velocity)")
            }
        }
        
        
        if contact.bodyA.node?.name == "block" {
            contact.bodyA.node?.removeFromParent()
            let children = self.children
            var childrenleft = false
            for node in children {
                if node.name == "block" {
                    childrenleft = true
                }
            }
            if !childrenleft {
                print("you won")
            }
        }
        if contact.bodyA.node?.name == "bottom" {
            print("GameOver")
        }
        if contact.bodyB.node?.name == "plate" {
            let plate = childNode(withName: "plate")!
            let ball = childNode(withName: "ball")!
            let plateWidth = plate.frame.width
            let diff = (plate.position.x - ball.position.x)
            var diffInPercent = (abs(diff) / (plateWidth/2)) * 100
            if diffInPercent > 50 { diffInPercent = 50 }
            let xSpeed = customSpeed * (diffInPercent / 100)
            ball.physicsBody?.velocity = CGVector(dx: diff > 0 ? -(xSpeed) : xSpeed, dy: customSpeed * ((100 - diffInPercent) / 100))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                fingerOnPlate = true
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
        customSpeed += 1/30
        guard let ball = childNode(withName: "ball") else { return }
        xVelo = ball.physicsBody!.velocity.dx
    }
}
