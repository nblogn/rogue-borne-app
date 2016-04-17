//
//  Hero.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//


import Foundation
import Darwin
import SpriteKit



class Hero: SKSpriteNode, basicCharacterAbilities {
    
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    var hitPoints: Int = 20

    var location: dungeonLocation

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {

        self.location = dungeonLocation.init(x: 10, y: 10)

        let texture = SKTexture(imageNamed: "RB_Hero")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())

        self.name = "hero"
        self.zPosition = 50
        
    }
    
    func getCurrentLocation() -> dungeonLocation {
        
        return location
    
    }
}

    
