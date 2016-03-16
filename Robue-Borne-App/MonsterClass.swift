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
    
    
    var hp: Int
    
    struct dungeonLocation {
        var x: Int
        var y: Int
    }
    
    
    var location: dungeonLocation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        hp = 100
        
        self.location = dungeonLocation.init(x: 20, y: 20)
        
        let texture = SKTexture(imageNamed: "RB_Monster1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "monster1"
        self.zPosition = 50
        
    }
    
    func move(aDungeon : Dungeon ) -> Void {
        // Let's just move randomly for now.
        // Pick a cardinal direction and check for collision
        // Repeat until a successful move has occurred or
        // the number of tries reaches 5. Dude could be trapped
        // like a Piner in a closet and we don't want to hang
    
        var hasMoved: Bool=false
        var numTries: Int=0
        var direction: Int
        
        
        while ( hasMoved == false ) && ( numTries < 5) {
        
            direction = Int(arc4random_uniform(3))
            
            switch direction {
            case 0:
                // Try north
                if self.getCurrentLocation().x > 0 {
                    if aDungeon.dungeonMap[self.getCurrentLocation().x-1][self.getCurrentLocation().y] == 0 {
                        self.setCurrentLocation(self.getCurrentLocation().x-1, Y: self.getCurrentLocation().y)
                        hasMoved = true
                    }
                }
            case 1:
                // Try south
                if self.getCurrentLocation().x < aDungeon.cellSizeHeight {
                    if aDungeon.dungeonMap[self.getCurrentLocation().x+1][self.getCurrentLocation().y] == 0 {
                        self.setCurrentLocation(self.getCurrentLocation().x+1, Y: self.getCurrentLocation().y)
                        hasMoved = true
                    }
                }
              
            case 2:
                // Try east
                if self.getCurrentLocation().y > 0 {
                    if aDungeon.dungeonMap[self.getCurrentLocation().x][self.getCurrentLocation().y-1] == 0 {
                        self.setCurrentLocation(self.getCurrentLocation().x, Y: self.getCurrentLocation().y-1)
                        hasMoved = true
                    }
                }
                
            case 3:
                // Try west
                if self.getCurrentLocation().y < aDungeon.cellSizeWidth {
                    if aDungeon.dungeonMap[self.getCurrentLocation().x][self.getCurrentLocation().y+1] == 0 {
                        self.setCurrentLocation(self.getCurrentLocation().x, Y: self.getCurrentLocation().y+1)
                        hasMoved = true
                    }
                }
            
            default:
                
                print("Fell through monster move switch")
            }
        
            numTries += 1
        }
        
    }
    
    func setCurrentLocation(X: Int, Y: Int) -> Void {
        location.x = X
        location.y = Y
    }
    
    func getCurrentLocation() -> dungeonLocation {
        
        return location
        
    }
}
