//
//  Constants.swift
//  Breakout_iOS
//
//  Created by Felix Wolf on 07.10.19.
//  Copyright © 2019 Felix Wolf. All rights reserved.
//

import Foundation

struct Constants {
    
    static let ignore = 0
    static let ball = 1 << 0
    static let block = 1 << 1
    static let plate = 1 << 2
    static let item = 1 << 3
    static let collidable = 1 << 4
    static let frame = 1 << 5
    static let bottom = 1 << 6
    static let statics = 1 << 7
}
/*
 00000000
 ||||||||_ ball
 |||||||_ block
 ||||||_ plate
 |||||_ item
 ||||_ collidable
 
 
 
 
 
 */
