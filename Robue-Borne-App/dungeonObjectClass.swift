//
//  dungeonObject.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//
//
// I'm thinking this will be the file that defines dungeon "things". 
// Such as monsters, heros, scrolls, lazer guns, chocobo testicles, etc.


import Foundation
import Darwin


//Create a class for a "thing" that is in a certain dungeon tile
//TODO: This should probably go in its own file???
class dungeonTileObject {
    
    
    //Ascii character set, I figure we should always support ascii.
    struct asciiDungeonArt {
        let floor:String = "."
        let wall:String = "="
        let vwall:String = "|"
        let nothing:String = " "
    }
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    //Would monsters, or people inherit from this base class?
    
    
}