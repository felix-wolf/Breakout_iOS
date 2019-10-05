//
//  BreakoutState.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation
import GameplayKit

class BreakoutState : GKState {
    
    var game: GameScene
    
    init(game: GameScene) {
        self.game = game
    }
    
    override func didEnter(from previousState: GKState?) {
        //do nothing
    }
    
    override func willExit(to nextState: GKState) {
        //do nothing
    }
    
    
}
