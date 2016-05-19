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


let tileSize = (width:32, height:32)


enum Tile: Int {
    
    case Ground
    case Wall
    case Nothing
    case Grass
    case CorridorVertical
    case CorridorHorizontal
    case Door
    
    var description:String {
        switch self {
        case Ground:
            return "Ground"
        case Wall:
            return "Wall"
        case Nothing:
            return "Nothing"
        case Grass:
            return "RB_Grass_2x"
        case CorridorVertical:
            return "CorridorVertical"
        case CorridorHorizontal:
            return "CorridorHorizontal"
        case Door:
            return "Door"
        }
    }
    
    var image:String {
        switch self {
        case Ground:
            return "RB_Floor_Green_2x"
        case Wall:
            return "RB_Wall_2x"
        case Nothing:
            return "RB_Floor_Grey_2x"
        case Grass:
            return "RB_Grass_2x"
        case CorridorVertical:
            return "CorridorVertical"
        case CorridorHorizontal:
            return "CorridorHorizontal"
        case Door:
            return "Door"
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
    
    init () {
        
        self.tileType = Tile.Nothing
        self.passable = false
        self.discovered = false
        
        let texture = SKTexture(imageNamed: self.tileType.image)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
    }
    
    init (tileToCreate:Tile) {
        
        self.tileType = tileToCreate
        
        switch self.tileType {
            case Tile.Ground:
                self.passable = true
            case Tile.Wall:
                self.passable = false
            case Tile.Nothing:
                self.passable = false
            case Tile.Grass:
                self.passable = true
            case Tile.CorridorVertical:
                self.passable = true
            case Tile.CorridorHorizontal:
                self.passable = true
            case Tile.Door:
                self.passable = true
            }
        
        self.discovered = false

        let texture = SKTexture(imageNamed: self.tileType.image)
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())

    }
}

