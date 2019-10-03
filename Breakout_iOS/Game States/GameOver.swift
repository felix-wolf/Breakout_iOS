//
//  GameOver.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 25.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import GameplayKit

class GameOver: GKState {
    
    required init(game: GameScene) {
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StartGame.Type
    }
}
