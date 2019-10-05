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
    let ball = Ball(texture: nil, color: UIColor.red, width: 10, height: 10, x: Int(UIScreen.main.bounds.width) / 2, y: Int(UIScreen.main.bounds.height) / 2, name: "ball")
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        game.addChild(ball)
        game.reset()
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: -(customSpeed))
    }
    
    override func willExit(to nextState: GKState) {
        ball.removeFromParent()
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
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
    }
    
    func contact(_ contact: SKPhysicsContact) {
        checkForGlitch()
        
        xVelo = ball.physicsBody!.velocity.dx
        var name: String?
        if contact.bodyA.node?.name == "ball" {
            name = contact.bodyB.node?.name
        } else {
            name = contact.bodyA.node?.name
        }
        
        switch name {
        case "block":
            contact.bodyA.node?.removeFromParent()
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
        case "bottom":
            stateMachine?.enter(GameOverState.self)
        case "plate":
            let plate = game.childNode(withName: "plate")!
            let ball = game.childNode(withName: "ball")!
            let plateWidth = plate.frame.width
            let diff = (plate.position.x - ball.position.x)
            var diffInPercent = (abs(diff) / (plateWidth/2)) * 100
            if diffInPercent > 70 { diffInPercent = 70 }
            let xSpeed = customSpeed * (diffInPercent / 100)
//            ball.physicsBody?.velocity = CGVector(dx: diff > 0 ? -(xSpeed) : xSpeed, dy: customSpeed * ((100 - diffInPercent) / 100))
            ball.physicsBody?.velocity = CGVector(dx: diff > 0 ? -(xSpeed) : xSpeed, dy: customSpeed)
        default:
            break
        }
    }
    
    func checkForGlitch() {
        if ball.physicsBody?.velocity.dx == 0.0 {
            ball.physicsBody?.velocity.dx = -xVelo
        } else {
            xVelo = ball.physicsBody!.velocity.dx
        }
    }

}
