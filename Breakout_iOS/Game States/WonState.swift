//
//  WonState.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import GameplayKit

class WonState: BreakoutState {


    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StartGameState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        game.childNode(withName: "youWon")?.run(game.scaleUp)
        game.childNode(withName: "ball")?.physicsBody?.velocity = CGVector.zero
    }
    
    override func willExit(to nextState: GKState) {
        game.removeBlocks()
        if nextState is StartGameState {
            game.childNode(withName: "youWon")?.run(game.scaleDown)
        }
    }
    
    
}
