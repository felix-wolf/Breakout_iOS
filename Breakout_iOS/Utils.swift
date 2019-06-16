//
//  Utils.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import SpriteKit
class Utils {
    
    var xCoordinates: [Int] = []
    var yCoordinates: [Int] = []
    var blockWidth = 0
    static let shared: Utils = Utils()
    
    func setUpPhysicsbody(body: SKPhysicsBody?, isDynamic: Bool, setRestitutionTo restitution: CGFloat) {
        if let body = body {
            body.restitution = restitution
            body.isDynamic = isDynamic
            body.friction = 0
            body.affectedByGravity = false
            body.allowsRotation = false
            body.linearDamping = 0
            body.angularDamping = 0
        }
    }
    
    func setUpXCoordinates(amountOfBlocksPerCollumn: Int, amountOfBlocksPerRow: Int) {
        
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            let yValue = Int(UIScreen.main.bounds.height) - (outerIndex * 50)
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
    
    func createBlock(index: Int, outerIndex: Int) -> SKSpriteNode {
        return Block(texture: nil, color: UIColor.white, size: CGSize(width: blockWidth - 1, height: 20), x: xCoordinates[index], y: yCoordinates[outerIndex], name: "block")
    }
}
