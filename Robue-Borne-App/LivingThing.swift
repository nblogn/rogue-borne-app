//
//  CharacterTileView.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 9/10/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
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


//This should matche the control input, I think.
enum HeroAction {
    
    case moveTo(DungeonLocation)
    case moveBy(DungeonLocation)
    case transportTo(DungeonLocation)
    
    /*Etc...
     case castSpell()
     case rangedAttack()
     case closeAttack()*/
    
}


enum KindsOfLivingThings {
    case hero
    case monster
    case otherMonster
}


class LivingThing: SKSpriteNode {
    
    
    var location: DungeonLocation
    var hitPoints: Int
    let maxHitPoints: Int
    let thingType: KindsOfLivingThings
    
    
    let hpMeter: SKSpriteNode
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    init(withThingType: KindsOfLivingThings, atLocation: DungeonLocation) {
        
        let texture: SKTexture
        let texture_n: SKTexture
        
        self.location = atLocation
        
        self.thingType = withThingType
        
        
        //Init textures based on thingType
        if self.thingType == .hero {
            texture = SKTexture(imageNamed: "Jaia_bw_head")
            texture_n = SKTexture(imageNamed: "Jaia_bw_n.png")
            self.hitPoints = 20
            self.maxHitPoints = 20
        } else {//monster
            texture = SKTexture(imageNamed: "monster_1")
            texture_n = SKTexture(imageNamed: "Jaia_bw_n.png")
            self.hitPoints = 5
            self.maxHitPoints = 5
        }
        
        
        //Hit Points meter (on character)
        hpMeter = SKSpriteNode(color: UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 0.95), size: CGSize(width: tileSize.width, height: (tileSize.height/10)))
        hpMeter.anchorPoint = CGPoint(x: 0, y: 0)
        hpMeter.position = CGPoint(x: -(tileSize.width/2), y: -(tileSize.height/2))
        hpMeter.zPosition = 51
        
        super.init(texture: texture, color: SKColor.clear, size: cgTileSize)

        
        if self.thingType == .hero {
            self.name = "hero"
            self.normalTexture = texture_n
        } else if self.thingType == .monster {
            self.name = "monster"
        }
        
        
        self.addChild(hpMeter)

        
        self.zPosition = 50
        
    }
    
    
    
    func hit(hpLost: Int) -> Void {
        
        
        //First check to see if we're still alive
        if hitPoints != 0 {
            
            hitPoints = hitPoints - hpLost
            
            let actionSequence = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(M_PI/8.0), duration:0.1),
                SKAction.rotate(byAngle: CGFloat(-M_PI/4.0), duration:0.1),
                SKAction.rotate(byAngle: CGFloat(M_PI/4.0), duration:0.1),
                SKAction.rotate(byAngle: CGFloat(-M_PI/4.0), duration:0.1),
                SKAction.rotate(byAngle: CGFloat(M_PI/8.0), duration:0.1)])
            
            self.run(actionSequence)
            
            if hitPoints == 0 {
                updateStatsView()
                dead()
            } else {
                updateStatsView()
            }
            
        }
        
    }
    
    
    func dead() -> Void {

        //Fade and blink out
        let scale = SKAction.scale(to: 0.1, duration: 0.5)
        let fade = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.run() {
            //Remove from parent--but it's still in the dictionary, hrmm.
            //I might want to do this in the parent, and also remove from dictionary
            self.removeFromParent()
        }
        
        let sequence = SKAction.sequence([scale, fade, remove])

        self.run(sequence)
        
    }
    
    
    
    private func updateStatsView() -> Void {
        
        let hpWidth = Int(Float(tileSize.width) * (Float(hitPoints) / Float(maxHitPoints)))
        
        hpMeter.size = CGSize(width: hpWidth, height: (tileSize.height/10))
        
    }
    
    
    
    func getStats () -> String {
        
        return "Mem: " + String(self.hitPoints)
    }
    
    
    
    func getCurrentLocation() -> DungeonLocation {
        
        return location
        
    }


    
    func setCurrentLocation(_ X: Int, Y: Int) -> Void {
        location.x = X
        location.y = Y
    }

    
}


