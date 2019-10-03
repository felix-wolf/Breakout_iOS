//
//  WaitingForTap.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 25.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import GameplayKit

class StartGame: GKState {
    
    var game: GameScene
    
    required init(game: GameScene) {
        self.game = game
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        game.childNode(withName: "gameMessage")!.run(scale)
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let scale = SKAction.scale(to: 0, duration: 0.4)
            game.childNode(withName: "gameMessage")!.run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
}
