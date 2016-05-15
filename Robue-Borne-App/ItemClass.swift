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
    
    var location: dungeonLocation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() { //Need to override with the image name... or more, to make this more configurable
        
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