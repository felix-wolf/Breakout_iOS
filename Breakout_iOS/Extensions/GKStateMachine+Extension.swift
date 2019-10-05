//
//  GKStateMachine+Extension.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 05.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import GameplayKit

extension GKStateMachine {
    
    func enterNextState() {
        switch currentState {
        case is StartGameState:
            enter(PlayingState.self)
        case is GameOverState, is WonState:
            enter(StartGameState.self)
        default: break
        }
    }
    
}
