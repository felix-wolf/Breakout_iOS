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
    
//    let ballCategory: UInt32 = 0x1 << 0
//    let botvarCategory: UInt32 = 0x1 << 1
//    let blockCategory: UInt32 = 0x1 << 2
//    let plateCategory: UInt32 = 0x1 << 3
    var stateMachine: GKStateMachine!
    let scaleUp = SKAction.scale(to: 2.0, duration: 0.25)
    let scaleDown = SKAction.scale(to: 0, duration: 0.25)
    
    override func didMove(to view: SKView) {
        
        stateMachine = GKStateMachine(states: [
            StartGameState(game: self),
            PlayingState(game: self),
            GameOverState(game: self),
            WonState(game: self)
            ])
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        let gameOverMessage = Utils.shared.createLabel(text: "Game over!", name: "gameOver")
        let tapToPlayMessage = Utils.shared.createLabel(text: "Tap to Play", name: "tapToPlay")
        let youWonMessage = Utils.shared.createLabel(text: "You won!", name: "youWon")
        addChild(youWonMessage)
        addChild(tapToPlayMessage)
        addChild(gameOverMessage)
        setupWorld()
        stateMachine.enter(StartGameState.self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        stateMachine.state(forClass: PlayingState.self)?.contact(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateMachine.state(forClass: PlayingState.self)?.fingerOnPlate = true
        stateMachine.enterNextState()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stateMachine.state(forClass: PlayingState.self)?.fingerOnPlate ?? false {
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
        stateMachine.state(forClass: PlayingState.self)?.fingerOnPlate = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        stateMachine.update(deltaTime: currentTime)
    }
    
    func setupWorld() {
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
        let plate = Block(texture: nil, color: UIColor.yellow, width: 80, height: 15, x: Int(UIScreen.main.bounds.width) / 2, y: 20, name: "plate")
        addChild(plate)
        Utils.shared.setUpPhysicsbody(body: plate.physicsBody, isDynamic: false, setRestitutionTo: 1)
    }
    
    func removeBlocks() {
        for node in children {
            if node.name == "block" {
                node.removeFromParent()
            }
        }
    }
    
    func reset() {
        childNode(withName: "ball")?.position = CGPoint(x: frame.midX, y: frame.midY)
        childNode(withName: "plate")?.position = CGPoint(x: Int(UIScreen.main.bounds.width) / 2, y: 20)
        stateMachine.state(forClass: PlayingState.self)?.customSpeed = 300
    }
}
