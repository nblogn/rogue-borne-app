//
//  MonsterClass.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/11/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import Darwin
import SpriteKit


class Monster: SKSpriteNode {
    
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    
    var location: dungeonLocation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        self.location = dungeonLocation.init(x: 20, y: 20)
        
        let texture = SKTexture(imageNamed: "RB_Monster1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "monster1"
        self.zPosition = 50
        
    }
    
    func getCurrentLocation() -> dungeonLocation {
        
        return location
        
    }
}
