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

    
    let initDungeonType: String
    
    
    let myDungeonMap = DungeonMap()
    let myHero: Hero
    let aMonster: Monster
    let levelExit: Item
    
    //Add a background
    let dungeonBackground = SKSpriteNode(texture: SKTexture(imageNamed: "gold-heatsink"), color: SKColor.clearColor(), size: SKTexture(imageNamed: "gold-heatsink").size())
    
    //Add a light source for the hero...
    var heroTorch = SKLightNode()
    
    
    //Add room lights
    var roomLights = [SKLightNode?()]
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    init(dungeonType: String) {
        
        
        self.myHero = Hero()
        self.aMonster = Monster()
        self.levelExit = Item()
        
        self.initDungeonType = dungeonType
        
        super.init()
        
        
        self.addChild(myDungeonMap)

        
    }
    

    func buildDungeonLevel() {
        

        //Change the different map creation algorithms to happen on UI button press
        switch initDungeonType {
            case "cellMap": myDungeonMap.createDungeonUsingCellMethod()
            case "cellAutoMap": myDungeonMap.generateDungeonRoomUsingCellularAutomota()
            case "bigBangMap": myDungeonMap.generateDungeonRoomsUsingFitLeftToRight()
        default:myDungeonMap.createDungeonUsingCellMethod()
        }
        
        //////////
        //Set the background
        dungeonBackground.position = CGPoint(x: ((myDungeonMap.dungeonSizeHeight*tileSize.width*2)/4), y: ((myDungeonMap.dungeonSizeHeight*tileSize.height*2)/4))
        dungeonBackground.zPosition = -1
        //Make the background twice as big as the dungeon map...
        dungeonBackground.size = CGSize(width: myDungeonMap.dungeonSizeHeight*tileSize.width*2, height: myDungeonMap.dungeonSizeHeight*tileSize.height*2)
        self.addChild(dungeonBackground)
        
        
        
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
        //Note that ambient/falloff have issues in spritekit:
        //http://stackoverflow.com/questions/29828324/spritekit-sklightnode-falloff-property-has-no-effect
        heroTorch.lightColor = UIColor.redColor()
        heroTorch.enabled = true
        heroTorch.categoryBitMask = LightCategory.Hero
        heroTorch.zPosition = 52
        heroTorch.position = CGPoint (x: 0, y: 0)
        
        //NOTE: THESE ARE IMPORTANT; shadowColor drastically changes shit.
        //heroTorch.ambientColor = UIColor.redColor()
        heroTorch.falloff = 1
        heroTorch.shadowColor = SKColor.blackColor().colorWithAlphaComponent(0.8)
        
        myHero.addChild(heroTorch)
        
        
        /////////
        //Set the room lighting
        //initLighting()
        
        
        //////////
        //Set the monsters
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
        levelExit.location = getFurthestLocationFromLocation(myHero.getCurrentLocation())
        
        
    }
    
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Initialize lighting
    //
    //-------------------------------------------------------------------------------------------//
    
    func initLighting () {
        
        //https://www.reddit.com/r/spritekit/comments/31vrmy/light_effect/
        
        
        var randomColor = UIColor()
        
        for drawRoomIterator in 0...(myDungeonMap.dungeonRooms.count - 1) {
            
            //Get a random num 1 or 2 or 3 (so, 33% of rooms will have a light)
            let shouldICreateALightInThisRoom = 1
            //Int(arc4random_uniform(UInt32(myDungeonMap.dungeonRooms.count/2)))
            
            if shouldICreateALightInThisRoom == 1 {
                
                randomColor = UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha: 0.5)
                
                let tempLight = SKLightNode()
                
                tempLight.lightColor = randomColor
                
                //tempLight.lightColor = SKColor.greenColor()
                //tempLight.ambientColor = UIColor.blackColor()
                tempLight.falloff = 1
                tempLight.shadowColor = UIColor.blackColor()
                tempLight.enabled = true
                tempLight.categoryBitMask = LightCategory.Hero
                tempLight.zPosition = 11
                tempLight.position = CGPoint (x: 0, y: 0)
                
                
                //Add the new light to our lights array
                roomLights.append(nil)
                roomLights[drawRoomIterator] = tempLight
                
                //Add the light as a child of level's (self) dungeon map
                //self.myDungeonMap.childNodeWithName(String(drawRoomIterator))?.addChild(roomLights[drawRoomIterator]!)
                
                //NOT WORKING!!!! TODO: ADD TO A NODE IN A RANDOM PART OF THE APPROPRIATE ROOM.
                
            } else {
                //Adding this to ensure lights index lines up with rooms index.
                //Eventually this should maybe be part of that struct
                roomLights.append(nil)
            }
        }
 
 
        
        /*
        let tempLight = SKLightNode()
        
        //tempLight.lightColor = randomColor
        
        tempLight.lightColor = SKColor.greenColor()
        tempLight.ambientColor = UIColor.blackColor()
        tempLight.falloff = 3
        tempLight.enabled = true
        tempLight.categoryBitMask = LightCategory.Hero
        tempLight.zPosition = 51
        tempLight.position = CGPoint (x: 0, y: 0)
        
        self.myDungeonMap.childNodeWithName("2")?.addChild(tempLight)
        */

        /*
        let tempLight = SKLightNode()
        tempLight.position = CGPoint (x: 0, y: 0)
        tempLight.falloff = 1.0
        tempLight.lightColor = SKColor(hue: 0.62 , saturation: 0.89, brightness: 1.0, alpha: 0.4)
        tempLight.shadowColor = SKColor.blackColor().colorWithAlphaComponent(0.4)
        self.myDungeonMap.childNodeWithName("2")?.addChild(tempLight)
        */
        
    }

    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Initialize hero
    //
    //-------------------------------------------------------------------------------------------//

    func initHero () {
        
        
    }

    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Initialize items (...treasue...)
    //
    //-------------------------------------------------------------------------------------------//

    func initItems () {
        
        
    }

    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Initialize monsters
    //
    //-------------------------------------------------------------------------------------------//
    
    func initMosters () {
    
    
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // MOVE characters and monsters
    //
    //-------------------------------------------------------------------------------------------//
    
    func moveHero(x:Int, y:Int) {
        
        switch myDungeonMap.dungeonMap[myHero.location.y + y][myHero.location.x + x].tileType {
            
        case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:

            //Figure out new hero location/position
            myHero.location.x = myHero.location.x + x
            myHero.location.y = myHero.location.y + y
            let xyPointDiff = convertBoardCoordinatetoCGPoint(myHero.location.x, y:myHero.location.y)
            
            //Move the background for parallax effect:
            let newBackgroundX = dungeonBackground.position.x - (CGFloat(tileSize.width) * CGFloat(x)*0.5)
            let newBackgroundY = dungeonBackground.position.y - (CGFloat(tileSize.height) * CGFloat(y)*0.35)
            let newDungeonBackgroundPosition = CGPoint(x: newBackgroundX, y: newBackgroundY)
            
            //Run the actions; do I need to group these to do in parallel???
            dungeonBackground.runAction(SKAction.moveTo(newDungeonBackgroundPosition, duration: 0.1))
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
    // Return Room information -- doing this for debugging, but may be useful later
    //
    //=====================================================================================================//

    func getRoomDetailsForLocation (location: dungeonLocation) -> DungeonMap.DungeonRoom? {
        
        var tempRoom: DungeonMap.DungeonRoom? = nil
        
        for roomIterator in 0...myDungeonMap.dungeonRooms.count-1 {

            if (location.x > myDungeonMap.dungeonRooms[roomIterator].location.x1) && (location.x < myDungeonMap.dungeonRooms[roomIterator].location.x2) && (location.y > myDungeonMap.dungeonRooms[roomIterator].location.y1) && (location.y < myDungeonMap.dungeonRooms[roomIterator].location.y2) {
                
                tempRoom = myDungeonMap.dungeonRooms[roomIterator]
                
            }
            
        }
        
        return tempRoom
    }
    
    
    
    
    
    
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
        
        
        let furthestLocation: dungeonLocation = dungeonLocation(x: 1, y: 1)
        
        //Implement farthest (or furthest) path algorithm...
        
        return furthestLocation
    }
    
    
    
    
    func getClosestLocationToLocation(sourceLocation: dungeonLocation) -> dungeonLocation {
        
        let closestLocation: dungeonLocation = dungeonLocation(x: 1, y: 1)
        
        //Implement nearest path algorithm...
        
        return closestLocation
        
    }
    
    
    
    
    
}