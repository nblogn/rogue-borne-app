//
//  DungeonLevel.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/23/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

class DungeonLevel: SKNode {

    
    let myDungeonMap = DungeonMap()
    let myHero: Hero
    let aMonster: Monster
    
    let myExit: Item
    
    
    //Add a light source for the hero...
    var ambientColor:UIColor?
    var heroTorch = SKLightNode();
    var dungeonLight = SKLightNode();
    

    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /* TODO:
     Add stuff for init() like...
     - Difficulty (How many monsters, how hard, etc)
     - Size of map
     */
    init(dungeonType: String) {
        
        
        self.myHero = Hero()
        self.aMonster = Monster()
        self.myExit = Item()
        
        //Change the different map creation algorithms to happen on UI button press
        switch dungeonType {
        case "cellMap": myDungeonMap.createDungeonUsingCellMethod()
        case "cellAutoMap": myDungeonMap.generateDungeonRoomUsingCellularAutomota()
        case "bigBangMap": myDungeonMap.generateDungeonRoomsUsingFitLeftToRight()
        default:myDungeonMap.createDungeonUsingCellMethod()
        }
        
        super.init()
        
        
        self.addChild(myDungeonMap)
        
        
        
        //////////
        //Set the hero
        myHero.location.x = myDungeonMap.dungeonRooms[myDungeonMap.dungeonRooms.count - 1].location.x1+1
        myHero.location.y = myDungeonMap.dungeonRooms[myDungeonMap.dungeonRooms.count - 1].location.y1+1
        myHero.position = convertBoardCoordinatetoCGPoint(myHero.location.x, y: myHero.location.y)
        //myHero.anchorPoint = CGPoint(x:0, y:0)
        myHero.zPosition = 5
        self.addChild(myHero)
        
        
        //////////
        //Set the hero's light:
        //heroTorch.position = CGPointMake(0,0)
        //Kind of prefer it with this off, but leaving it on to see monsters:
        //NOTE: My floors are currently only normal maps, so ambient doesn't work
        //heroTorch.ambientColor = UIColor.whiteColor()
        //heroTorch.falloff = 1
        heroTorch.lightColor = UIColor.redColor()
        heroTorch.enabled = true
        heroTorch.categoryBitMask = LightCategory.Hero
        heroTorch.zPosition = 51
        heroTorch.position = CGPoint (x: 0, y: 0)
        myHero.addChild(heroTorch)
        
        
        
        //////////
        //Set the monster
        aMonster.location.x = myDungeonMap.dungeonRooms[0].location.x1 + 1
        aMonster.location.y = myDungeonMap.dungeonRooms[0].location.y1 + 1
        aMonster.position = convertBoardCoordinatetoCGPoint(aMonster.location.x, y: aMonster.location.y)
        //aMonster.anchorPoint = CGPoint(x:0, y:0)
        aMonster.zPosition = 5
        
        //Added a shadow to the monster
        aMonster.shadowCastBitMask = LightCategory.Hero
        aMonster.lightingBitMask = LightCategory.Hero
        self.addChild(aMonster)
        
        //Light the monster on fire
        if let particles = SKEmitterNode(fileNamed: "FireParticle.sks") {
            //particles.position = player.position
            aMonster.addChild(particles)
        }
        

        /////////
        //Set the Exit
        
        myExit.location = getFurthestLocationFromLocation(myHero.getCurrentLocation())
        
    }
    

    
    
    //-------------------------------------------------------------------------------------------//
    //
    // MOVE characters and monsters
    //
    //-------------------------------------------------------------------------------------------//
    
    func moveHero(x:Int, y:Int) {
        
        switch myDungeonMap.dungeonMap[myHero.location.y + y][myHero.location.x + x].tileType {
            
        case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
            myHero.location.x = myHero.location.x + x
            myHero.location.y = myHero.location.y + y
            
            let xyPointDiff = convertBoardCoordinatetoCGPoint(myHero.location.x, y:myHero.location.y)
            
            //let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
            //    SKAction.rotateByAngle(0.0, duration: 0.1),
            //    SKAction.rotateByAngle(degToRad(4.0), duration: 0.1),
            //    SKAction.moveTo(xyPointDiff, duration: 0.2)])
            
            myHero.runAction(SKAction.moveTo(xyPointDiff, duration: 0.1))
            
        default: break
        }
        
    }//moveHero()
    
    
    func moveMonster() -> Void {
        // Let's just move randomly for now.
        // Pick a cardinal direction and check for collision
        // Repeat until a successful move has occurred or
        // the number of tries reaches 5. Dude could be trapped
        // like a Piner in a closet and we don't want to hang
        // JOSH: LOL!
        
        var hasMoved: Bool=false
        var numTries: Int=0
        var direction: Int
        
        
        while ( hasMoved == false ) && ( numTries < 5) {
            
            direction = Int(arc4random_uniform(4))
            
            
            switch direction {
            case 0:
                // Try north
                
                switch myDungeonMap.dungeonMap[aMonster.getCurrentLocation().y-1][aMonster.getCurrentLocation().x].tileType  {
                    
                case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                    aMonster.setCurrentLocation(aMonster.getCurrentLocation().x, Y: aMonster.getCurrentLocation().y-1)
                    hasMoved = true
                default:
                    break
                }
                
            case 1:
                // Try south
                
                switch myDungeonMap.dungeonMap[aMonster.getCurrentLocation().y+1][aMonster.getCurrentLocation().x].tileType {
                    
                case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                    aMonster.setCurrentLocation(aMonster.getCurrentLocation().x, Y: aMonster.getCurrentLocation().y+1)
                    hasMoved = true
                default:
                    break
                }
                
                
            case 2:
                // Try east
                
                switch myDungeonMap.dungeonMap[aMonster.getCurrentLocation().y][aMonster.getCurrentLocation().x-1].tileType {
                    
                case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                    aMonster.setCurrentLocation(aMonster.getCurrentLocation().x-1, Y: aMonster.getCurrentLocation().y)
                    hasMoved = true
                default:
                    break
                }
                
                
            case 3:
                // Try west
                
                switch myDungeonMap.dungeonMap[aMonster.getCurrentLocation().y][aMonster.getCurrentLocation().x+1].tileType {
                    
                case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                    aMonster.setCurrentLocation(aMonster.getCurrentLocation().x+1, Y: aMonster.getCurrentLocation().y)
                    hasMoved = true
                default:
                    break
                }
                
                
            default:
                
                print("Fell through monster move switch")
            }
            
            numTries += 1
        }
        
        let xyPointDiff = convertBoardCoordinatetoCGPoint(aMonster.location.x, y:aMonster.location.y)
        
        aMonster.runAction(SKAction.moveTo(xyPointDiff, duration: 0.1))
        
    }//moveMonster()
    
    
    
    //=====================================================================================================//
    // PATHFINDING Utilities
    //
    // Find locations far away from, and closest to a given location
    //
    // Also could use an "explore everything until you hit something" function, this is for the
    // auto explore modes in more modern roguelikes.
    //
    //=====================================================================================================//
    
    
    //Set a farthest (furthest?) path location away from the given (hero's) starting point
    func getFurthestLocationFromLocation(sourceLocation: dungeonLocation) -> dungeonLocation {
        
        
        var furthestLocation: dungeonLocation = dungeonLocation(x: 1, y: 1)
        
        //Implement farthest path algorithm...
        
        return furthestLocation
    }
    
    
    
    
    func getClosestLocationToLocation(sourceLocation: dungeonLocation) -> dungeonLocation {
        
        var closestLocation: dungeonLocation = dungeonLocation(x: 1, y: 1)
        
        //Implement nearest path algorithm...
        
        return closestLocation
        
    }
    
    
    
    
    
}