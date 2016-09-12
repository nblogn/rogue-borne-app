//
//  testScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/17/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene: SKScene {
    
   
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red:0.39, green:0.36, blue:0.15, alpha:1)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotate(byAngle: CGFloat(M_PI/8), duration:1)
            
            sprite.run(SKAction.repeatForever(action))
            
            self.addChild(sprite)
        }
        
        
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
