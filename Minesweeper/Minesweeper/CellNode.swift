//
//  CellNode.swift
//  Minesweeper
//
//  Created by Brian Malsan on 4/20/19.
//  Copyright © 2019 Brian Malsan. All rights reserved.
//

import Foundation
import SpriteKit


class CellNode : SKShapeNode{
    
    var isMine:Bool = false
    var isClicked:Bool = false
    var isFlagged:Bool = false
    var numNeighborsWithMine:Int = 0
    
    
    
}
