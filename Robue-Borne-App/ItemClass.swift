//
//  ItemClass.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/11/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import Darwin
import SpriteKit


class Item: SKSpriteNode {
    
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    
    var location: dungeonLocation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        self.location = dungeonLocation.init(x: 15, y: 15)
        
        let texture = SKTexture(imageNamed: "RB_Item")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "item"
        self.zPosition = 50
        
    }
    
    func getCurrentLocation() -> dungeonLocation {
        
        return location
        
    }
}