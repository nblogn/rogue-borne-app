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
import SpriteKit

//Create a class for a "thing" that is in a certain dungeon tile
//TODO: This should probably go in its own file???
class Hero: SKSpriteNode {
    
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    
    var heroLocation: dungeonLocation

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {

        self.heroLocation = dungeonLocation.init(x: 10, y: 10)

        let texture = SKTexture(imageNamed: "RB_Hero")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())

        self.name = "hero"
        self.zPosition = 50
        
    }
    
    func getCurrentLocation() -> dungeonLocation {
        
        return heroLocation
    
    }
}

    
/*
class DungeonMonster: DungeonObject {
    
    
}
*/