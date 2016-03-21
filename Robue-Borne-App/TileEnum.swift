//
//  TileEnum.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/20/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation

//-------------------------------------------------------------------------------------------//
//
// Used for all dungeone tiles everywhere.
//
//-------------------------------------------------------------------------------------------//

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


