//
//  Playing.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 25.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import GameplayKit

class PlayingState: BreakoutState {
    
    var customSpeed: CGFloat = 300
    var xVelo: CGFloat = 0
    var fingerOnPlate = false
    var ball: Ball? {
        return (game.childNode(withName: "ball") as? Ball) ?? nil
    }
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        createBall()
        game.reset()
    }
    
    override func willExit(to nextState: GKState) {
        for node in game.children {
            if node.name == "ball" {
                node.removeFromParent()
            } else if node.name == "item" {
                let item = node as? BreakoutItem
                item?.stopTimer()
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameOverState.Type, is WonState.Type:
            return true
        default:
            return false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        customSpeed += 1/20
        let nodes = game.children
        for node in nodes {
            if node.name == "ball" {
                checkForGlitch(ball: node as! Ball)
            }
        }
    }
    
    func contact(_ contact: SKPhysicsContact) {
        
        var otherNode: SKNode?
        var ballNode: SKNode?
        var frameNode: SKNode?
        
        if contact.bodyA.node?.name == "ball" {
            ballNode = contact.bodyA.node!
            otherNode = contact.bodyB.node!
        } else if contact.bodyB.node?.name == "ball" {
            ballNode = contact.bodyB.node!
            otherNode = (contact.bodyA.node)!
        } else if contact.bodyA.node?.name == "item" {
            otherNode = contact.bodyA.node!
            frameNode = contact.bodyB.node!
        } else if contact.bodyB.node?.name == "item" {
            otherNode = contact.bodyB.node!
            frameNode = contact.bodyA.node!
        }
      
        let name = otherNode?.name
        
        switch name {
        case "block":
            collisionWithBlock(node: otherNode)
        case "bottom":
            collisionWithBottom()
        case "plate":
            collisionWithPlate(ball: ballNode)
        case "item":
            collisionWithItem(firstNode: otherNode, secondNode: frameNode)
        default:
            break
        }
    }
    
    func collisionWithBlock(node: SKNode?) {
        if node != nil {
            node?.removeFromParent()
            
            if let block = node as? Block {
                print(block.hasItem)
                if block.hasItem {
                    let item = BreakoutItem(radius: 5, type: block.item, containingBlock: block, game: game)
                    //                let item = BreakoutItem(type: block.item, containingBlock: block, game: game, color: UIColor.green)
                    game.addChild(item)
                    item.physicsBody?.velocity.dy = -200
                }
            }
        }
        
        let children = game.children
        var childrenleft = false
        for node in children {
            if node.name == "block" {
                childrenleft = true
            }
        }
        if !childrenleft {
            stateMachine?.enter(WonState.self)
        }
    }
    
    func collisionWithBottom() {
        
        ball?.removeFromParent()
        var noBallsLeft = true
        for node in game.children {
            if node.name == "ball" {
                noBallsLeft = false
            }
        }
        if noBallsLeft {
            stateMachine?.enter(GameOverState.self)
        }
    }
    
    func collisionWithPlate(ball: SKNode?) {
        guard let ball = ball else { return }
            let plate = game.childNode(withName: "plate")!
            let plateWidth = plate.frame.width
        let diff = (plate.position.x - ball.position.x)
            var diffInPercent = (abs(diff) / (plateWidth/2)) * 100
            if diffInPercent > 70 { diffInPercent = 70 }
            let xSpeed = customSpeed * (diffInPercent / 100)
            //            ball.physicsBody?.velocity = CGVector(dx: diff > 0 ? -(xSpeed) : xSpeed, dy: customSpeed * ((100 - diffInPercent) / 100))
        ball.physicsBody?.velocity = CGVector(dx: diff > 0 ? -(xSpeed) : xSpeed, dy: customSpeed)
    }
    
    func collisionWithItem(firstNode: SKNode?, secondNode: SKNode?) {
        if secondNode?.name != "bottom" {
            if let item = firstNode as? BreakoutItem {
                item.activate()
                item.removeFromParent()
            }
        }
    }
    
    func checkForGlitch(ball: Ball) {
        if ball.physicsBody?.velocity.dx == -0.0 {
            ball.physicsBody?.velocity.dx = -xVelo
        } else if ball.physicsBody?.velocity.dy == 0.0 {
            ball.physicsBody?.velocity.dy = customSpeed
        } else {
            xVelo = ball.physicsBody!.velocity.dx
        }
    }
    
    func createBall() {
        let ball =  Ball(texture: nil, color: UIColor.red, width: 10, height: 10, x: Int(UIScreen.main.bounds.width) / 2, y: Int(UIScreen.main.bounds.height) / 2, name: "ball")
        game.addChild(ball)
        ball.physicsBody?.velocity = CGVector(dx: 1, dy: -(customSpeed))
    }
    
    
}
