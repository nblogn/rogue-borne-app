//
//  TileEnum.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/20/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

//-------------------------------------------------------------------------------------------//
//
// Used for all dungeone tiles everywhere.
//
//-------------------------------------------------------------------------------------------//


//Ascii character set, I figure we should always support ascii. This should probably go in the dungeon though,
//since inanimate "things" are part of the dungeon class.
//TODO: Where should this live and how should it work?
/*
struct asciiDungeonObjectArt {
    let floor:String = "."
    let wall:String = "="
    let vwall:String = "|"
    let nothing:String = " "
}
*/



//Set the tile size
//NOTE: Lots of the logic in the code changes based on this value!
let tileSize = (width:500, height:500)
let cgTileSize = CGSize(width: 500, height: 500)
let miniTileSize = (width:3, height: 3)



enum Tile: Int {
    
    case ground
    case wall
    case nothing
    case grass
    case corridorVertical
    case corridorHorizontal
    case door
    case fan
    
    var description:String {
        switch self {
        case .ground:
            return "Ground"
        case .wall:
            return "Wall"
        case .nothing:
            return "Nothing"
        case .grass:
            return "RB_Grass_2x"
        case .corridorVertical:
            return "corridorVertical"
        case .corridorHorizontal:
            return "corridorHorizontal"
        case .door:
            return "Door"
        case .fan:
            return "fan"
        }
    }
    
    var image:String {
        switch self {
        case .ground:
            return "RB_Floor_Green_2x"
        case .wall:
            return "RB_Wall_2x"
        case .nothing:
            return "RB_Floor_Grey_2x"
        case .grass:
            return "RB_Grass_2x"
        case .corridorVertical:
            return "bricksNormal"
        case .corridorHorizontal:
            return "bricksNormal"
        case .door:
            return "Door"
        case .fan:
            return "fan"
        }
    }
    
}



class TileClass: SKSpriteNode {

    var tileType: Tile
    var passable: Bool
    var discovered: Bool
    
    //Default init in case of errors...
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Init a default "nothing" tile
    init () {
        
        self.tileType = Tile.nothing
        self.passable = false
        self.discovered = false
        
        let texture = SKTexture(imageNamed: self.tileType.image)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
    }
    
    //Init a given tile type
    init (tileToCreate:Tile) {
        
        self.tileType = tileToCreate
        
        switch self.tileType {
            case Tile.ground:
                self.passable = true
            case Tile.wall:
                self.passable = false
            case Tile.nothing:
                self.passable = false
            case Tile.grass:
                self.passable = true
            case Tile.corridorVertical:
                self.passable = true
            case Tile.corridorHorizontal:
                self.passable = true
            case Tile.door:
                self.passable = true
            case Tile.fan:
                self.passable = false
            }
        
        self.discovered = false

        let texture = SKTexture(imageNamed: self.tileType.image)
        super.init(texture: texture, color: SKColor.clear, size: cgTileSize)
        
        self.size = cgTileSize
        
        //Add normalMap for the corridors (bricks)
        if (self.tileType == .corridorVertical) || (self.tileType == .corridorHorizontal) {
            self.normalTexture = texture
        }

    }
}

