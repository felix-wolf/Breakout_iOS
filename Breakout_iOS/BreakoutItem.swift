//
//  BreakoutItem.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import Foundation

public enum ItemType: String {
    case speedUp
    case speedDown
    case newBall
    case plateShrink
    case plateEnlarge
    case ballShrink
    case ballEnlarge
    case none
    
    static func randomValue() -> ItemType {
        let values: [ItemType] = [.speedUp, .speedDown, .newBall, .plateShrink, .plateEnlarge, .ballShrink, .ballEnlarge]
        let index = Int(arc4random_uniform(UInt32(values.count)))
        let value = values[index]
        return value
    }
    static func color(type: ItemType) -> UIColor {
        switch type {
        case .newBall, .ballEnlarge, .plateEnlarge, .speedDown:
            return UIColor.green
        case .ballShrink, .plateShrink, .speedUp:
            return UIColor.red
        default: break
        }
        return UIColor.purple
    }
}

class BreakoutItem: SKShapeNode {
    
    var type: ItemType
    var containingBlock: Block
    var game: GameScene
    var timer = Timer()
    
    init(block: Block, game: GameScene) {
        self.type = .none
        self.containingBlock = block
        self.game = game
        super.init()
    }
    
    convenience init(radius: CGFloat, type: ItemType, containingBlock: Block, game: GameScene) {
        self.init(block: containingBlock, game: game)
        self.type = type
        self.containingBlock = containingBlock
        self.game = game
        let rect = CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2)
        self.path = CGPath(ellipseIn: rect, transform: nil)
        self.fillColor = ItemType.color(type: type)
        self.strokeColor = ItemType.color(type: type)
        self.name = "item"
        self.position = containingBlock.position
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        Utils.shared.setUpPhysicsbody(body: self.physicsBody, isDynamic: true, setRestitutionTo: 1, objectType: .Item)//, affectedByGravity: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        guard let plate = game.childNode(withName: "plate") as? Block else { return }
        var balls: [Ball] = []
        for child in game.children {
            if child.name == "ball" {
                balls.append(child as! Ball)
            }
        }
        createTimer()
        switch type {
        case .speedUp:
            game.stateMachine.state(forClass: PlayingState.self)?.customSpeed += 100
        case .speedDown:
            game.stateMachine.state(forClass: PlayingState.self)?.customSpeed -= 100
        case .newBall:
            _ = game.stateMachine.state(forClass: PlayingState.self)?.createBall()
            stopTimer()
        case .plateShrink:
            plate.size.width -= 40
            updatePhysicsBody(node: plate, type: .Plate)
        case .plateEnlarge:
            plate.size.width += 40
            updatePhysicsBody(node: plate, type: .Plate)
        case .ballShrink:
            for ball in balls {
                ball.size.width -= 3
                ball.size.height -= 3
            }
        case .ballEnlarge:
            for ball in balls {
                ball.size.width += 3
                ball.size.height += 3
            }
            
        default: break
        }
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(deactivate), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func deactivate() {
        guard let plate = game.childNode(withName: "plate") as? Block else { return }
        var balls: [Ball] = []
        for child in game.children {
            if child.name == "ball" {
                balls.append(child as! Ball)
            }
        }
        switch type {
        case .speedUp:
            game.stateMachine.state(forClass: PlayingState.self)?.customSpeed -= 100
        case .speedDown:
            game.stateMachine.state(forClass: PlayingState.self)?.customSpeed += 100
        case .plateShrink:
            plate.size.width += 40
            updatePhysicsBody(node: plate, type: .Plate)
        case .plateEnlarge:
            updatePhysicsBody(node: plate, type: .Plate)
            plate.size.width -= 40
        case .ballShrink:
            for ball in balls {
                ball.size.width += 3
                ball.size.height += 3
            }
        case .ballEnlarge:
            for ball in balls {
                ball.size.width -= 3
                ball.size.height -= 3
            }
        default: break
        }
    }
    
    func updatePhysicsBody(node: Block, type: Object) {
        node.physicsBody = nil
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width, height: node.size.height))
        Utils.shared.setUpPhysicsbody(body: node.physicsBody, isDynamic: false, setRestitutionTo: 1, objectType: type)
    }
    
}
