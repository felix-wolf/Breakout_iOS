//
//  WaitingForTap.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 25.06.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartGameState: BreakoutState {
    
    let amountOfBlocksPerRow = 6
    let amountOfBlocksPerCollumn = 4
    
    required override init(game: GameScene) {
        super.init(game: game)
    }
    
    override func didEnter(from previousState: GKState?) {
        game.reset()
        super.didEnter(from: previousState)
        game.childNode(withName: "tapToPlay")!.run(game.scaleUp)
        
        Utils.shared.setUpXCoordinates(amountOfBlocksPerCollumn: amountOfBlocksPerCollumn, amountOfBlocksPerRow: amountOfBlocksPerRow)
        for outerIndex in 0..<amountOfBlocksPerCollumn {
            for index in 0..<amountOfBlocksPerRow {
                game.addChild(Utils.shared.createBlock(index: index, outerIndex: outerIndex))
            }
        }
        Utils.shared.clearCoordinates()
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is PlayingState {
            game.childNode(withName: "tapToPlay")!.run(game.scaleDown)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
}
