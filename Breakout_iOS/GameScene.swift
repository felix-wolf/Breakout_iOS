//
//  GameScene.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 30.05.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var coordinates: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    
    override func didMove(to view: SKView) {
        
        var i = 0
        for _ in 0...5 {
            coordinates[i] = Double((UIScreen.main.bounds.width / 10)) * Double(i)
            i += 1
        }
        
        //        // Get  label node from scene and store it for use later
        //        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        //        if let label = self.label {
        //            label.alpha = 0.0
        //            label.run(SKAction.fadeIn(withDuration: 2.0))
        //        }
        
        // Create shape node to use during mouse interaction
        i = 0
        for _ in 0...1 {
            let node = Block(texture: nil, color: UIColor.black, size: CGSize(width: 100, height: 100), x: coordinates[i], y: Double(UIScreen.main.bounds.height))
            i += 1
            self.addChild(node)
        }
        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
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
