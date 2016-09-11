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
        
        // SPRITE
        let sprite = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
        sprite.position = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        sprite.lightingBitMask = 1
        sprite.shadowCastBitMask = 1
        self.addChild(sprite)
        
        // LIGHT
        let light = SKLightNode()
        light.position = CGPoint(x: self.frame.width / 2.0, y: 100.0)
        light.categoryBitMask = 1
        self.addChild(light)
        
        
        let myHero: LivingThing = LivingThing(withThingType: KindsOfLivingThings.hero)
        let aMonster: LivingThing = LivingThing(withThingType: KindsOfLivingThings.monster)
        let heroTorch: SKLightNode = SKLightNode()
        
        
        //////////
        //Set the hero
        myHero.location.x = 10
        myHero.location.y = 10
        myHero.position = convertBoardCoordinatetoCGPoint(x: myHero.location.x, y: myHero.location.y)
        //myHero.anchorPoint = CGPoint(x:0, y:0)
        myHero.zPosition = 5
        addChild(myHero)
        
        
        //////////
        //Set the hero's light:
        //heroTorch.position = CGPointMake(0,0)
        //Kind of prefer it with this off, but leaving it on to see monsters:
        //NOTE: My floors are currently only normal maps, so ambient doesn't work
        //heroTorch.ambientColor = UIColor.whiteColor()
        //heroTorch.falloff = 1
        heroTorch.lightColor = UIColor.red
        heroTorch.isEnabled = true
        heroTorch.categoryBitMask = LightCategory.Hero
        heroTorch.zPosition = 51
        heroTorch.position = CGPoint (x: 0, y: 0)
        myHero.addChild(heroTorch)
        
        
        
        //////////
        //Set the monster
        aMonster.location.x = 5
        aMonster.location.y = 10
        aMonster.position = convertBoardCoordinatetoCGPoint(x: aMonster.location.x, y: aMonster.location.y)
        //aMonster.anchorPoint = CGPoint(x:0, y:0)
        aMonster.zPosition = 5
        
        //Added a shadow to the monster
        aMonster.shadowCastBitMask = LightCategory.Hero
        addChild(aMonster)

        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
            
            sprite.run(SKAction.repeatForever(action))
            
            self.addChild(sprite)
        }
        
        
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
