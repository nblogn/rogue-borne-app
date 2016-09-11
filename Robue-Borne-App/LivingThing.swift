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
    var hitPoints: Int = 20

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    init(livingThing: KindsOfLivingThings) {
        
        self.location = DungeonLocation.init(x: 10, y: 10)
        
        let heroTexture = SKTexture(imageNamed: "Jaia_bw_head")
        let heroTexture_n = SKTexture(imageNamed: "Jaia_bw_n.png")
        
        super.init(texture: heroTexture, color: SKColor.clear, size: cgTileSize)
        
        print(heroTexture.size())
        
        //super.init(texture: heroTexture, normalMap: heroTexture_n)
        
        self.normalTexture = heroTexture_n
        self.name = "hero"
        self.zPosition = 50
        
    }
    
    
    init(monster: Monster) {
        
        monster.hp = 100
        
        self.location = DungeonLocation.init(x: 20, y: 20)
        
        let texture = SKTexture(imageNamed: "monster_1")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "monster"
        self.zPosition = 50
        
        
    }
    
    
    func getCurrentLocation() -> DungeonLocation {
        
        return location
        
    }
    
    
    
    func getStats () -> String {
        
        return "Mem: " + String(self.hitPoints)
    }
    
    
    
    
}


