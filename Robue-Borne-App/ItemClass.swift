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
    
    var location: DungeonLocation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() { //Need to override with the image name... or more, to make this more configurable
        
        self.location = DungeonLocation.init(x: 15, y: 15)
        
        let texture = SKTexture(imageNamed: "Door")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "item"
        self.zPosition = 50
        
    }
    
    func getCurrentLocation() -> DungeonLocation {
        
        return location
        
    }
    
    
}
