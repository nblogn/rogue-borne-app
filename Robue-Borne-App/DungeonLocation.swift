//
//  DungeonLocation.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 8/31/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


struct DungeonLocation {
    var x: Int
    var y: Int
}



//-------------------------------------------------------------------------------------------//
//Handling board coordinate space
//Generic func to place a tile on the board.
//Given a board position convert to CGPoint
//From me: I probably need some conversions of array coordinates to CGPoint coordinate...
//-------------------------------------------------------------------------------------------//
func convertBoardCoordinatetoCGPoint (x: Int, y: Int, mini: Bool = false) -> CGPoint {
    
    let retX: Int
    let retY: Int
    
    if mini == true {
        
        retX = x * miniTileSize.width
        retY = y * miniTileSize.height
        
    } else {
        
        retX = x * tileSize.width
        retY = y * tileSize.height
        
    }
    
    return CGPoint(x: retX, y: retY)
    
}



