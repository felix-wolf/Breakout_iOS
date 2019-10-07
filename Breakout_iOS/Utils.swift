//
//  Utils.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import SpriteKit

public enum Object {
    case Block
    case Plate
    case Item
    case Frame
    case Bottom
    case Ball
}

struct Utils {
    
    var xCoordinates: [Int] = []
    var yCoordinates: [Int] = []
    var blockWidth = 0
    static var shared: Utils = Utils()
    
    func setUpPhysicsbody(body: SKPhysicsBody?, isDynamic: Bool, setRestitutionTo restitution: CGFloat, objectType: Object, affectedByGravity: Bool = false) {
        if let body = body {
            body.restitution = restitution
            body.isDynamic = isDynamic
            body.friction = 0
            body.affectedByGravity = affectedByGravity
            body.allowsRotation = false
            body.linearDamping = 0
            body.angularDamping = 0
            
            switch objectType {
            case .Block:
                body.categoryBitMask = UInt32(Constants.collidable + Constants.block)
                body.collisionBitMask = UInt32(Constants.statics)
                body.contactTestBitMask = UInt32(Constants.collidable + Constants.block)
            case .Plate:
                body.categoryBitMask = UInt32(Constants.plate + Constants.collidable)
                body.collisionBitMask = UInt32(Constants.statics)
                body.contactTestBitMask = UInt32(Constants.collidable + Constants.item + Constants.ball)
            case .Item:
                body.categoryBitMask = UInt32(Constants.item)
                body.contactTestBitMask = UInt32(Constants.item)
                body.collisionBitMask = UInt32(Constants.ignore)
            case .Frame:
                body.categoryBitMask = UInt32(Constants.collidable + Constants.statics + Constants.frame)
                body.collisionBitMask = UInt32(Constants.statics)
                body.contactTestBitMask = UInt32(Constants.collidable + Constants.frame)
            case .Bottom:
                body.categoryBitMask = UInt32(Constants.bottom)
                body.collisionBitMask = UInt32(Constants.ignore)
                body.contactTestBitMask = UInt32(Constants.ball)
            case .Ball:
                body.categoryBitMask = UInt32(Constants.collidable + Constants.ball)
                body.contactTestBitMask = UInt32(Constants.collidable + Constants.ball)
                body.collisionBitMask = UInt32(Constants.collidable + Constants.ball)
            }
        }
        
    }
    
    mutating func setUpXCoordinates(amountOfBlocksPerCollumn: Int, amountOfBlocksPerRow: Int) {
        
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            let yValue = Int(UIScreen.main.bounds.height) - (outerIndex * 30)
            yCoordinates.append(yValue)
            yCoordinates[outerIndex] -= 15
        }
        
        blockWidth = Int(UIScreen.main.bounds.width) / amountOfBlocksPerRow
        for index in 0..<amountOfBlocksPerRow {
            let xValue = blockWidth * index
            xCoordinates.append(xValue)
            xCoordinates[index] += (blockWidth) / 2
        }
        blockWidth -= 3
    }
    
    mutating func clearCoordinates() {
        xCoordinates.removeAll()
        yCoordinates.removeAll()
    }
    
    func createBlock(index: Int, outerIndex: Int) -> SKSpriteNode {
        return Block(texture: nil, color: UIColor.white, width: Double(blockWidth - 1), height: 10, x: xCoordinates[index], y: yCoordinates[outerIndex], name: "block")
    }
    
    func createLabel(text: String, name: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.name = name
        label.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        label.zPosition = 4
        label.setScale(0.0)
        return label
    }
}
