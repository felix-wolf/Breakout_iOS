//
//  GameOver.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 25.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: BreakoutState {
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StartGameState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        game.childNode(withName: "gameOver")?.run(game.scaleUp)
    }
    
    override func willExit(to nextState: GKState) {
        game.removeBlocks()
        if nextState is StartGameState {
            game.childNode(withName: "gameOver")?.run(game.scaleDown)
        }
    }
}
