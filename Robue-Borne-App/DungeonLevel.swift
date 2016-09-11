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

    
    //-------------------------------------------------------------------------------------------//
    //
    //Global lets and vars for the class
    //
    //-------------------------------------------------------------------------------------------//
    
    let initDungeonType: String
    
    let myDungeonMap = DungeonMap()

    let myHero: LivingThing

    let aMonster: LivingThing
    var monsterDictionary: Dictionary<DungeonLocation, LivingThing>

    let levelExit: Item
    
    let combatCoordinator: CombatCoordinator
    
    //Add a background
    let dungeonBackground = SKSpriteNode(texture: SKTexture(imageNamed: "gold-heatsink"), color: SKColor.clear, size: SKTexture(imageNamed: "gold-heatsink").size())
    
    //let dungeonBackground = SKSpriteNode(texture: SKTexture(imageNamed: "#imageLiteral(resourceName: "gold-heatsink")"), normalMap: SKTexture(imageNamed: "#imageLiteral(resourceName: "gold-heatsink-n")"))
    
    //Add a light source for the hero...
    var heroTorch = SKLightNode()
    
    //Add room lights
    var roomLights = [SKLightNode()]
    
    

    //-------------------------------------------------------------------------------------------//
    //
    // INITS and BuildDungeonLevel
    //
    //-------------------------------------------------------------------------------------------//

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    init(dungeonType: String) {
        
        self.myHero = LivingThing(withThingType: KindsOfLivingThings.hero, atLocation: DungeonLocation(x: 1, y: 1))

        self.levelExit = Item()
        
        self.initDungeonType = dungeonType
                
        self.combatCoordinator = CombatCoordinator()
        
        self.aMonster = LivingThing(withThingType: KindsOfLivingThings.monster, atLocation: DungeonLocation(x:1, y:1))
        self.monsterDictionary = [aMonster.location: aMonster]
        
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
        let dbn = SKTexture(imageNamed: "gold-heatsink-n")
        dungeonBackground.normalTexture = dbn
        dungeonBackground.lightingBitMask = LightCategory.Hero
        self.addChild(dungeonBackground)
        
        
        
        //////////
        //Set the hero
        self.initHero()
        

        /////////
        //Create and position the monsters
        self.initMosters()
        
        
        
        /////////
        //Set the room lighting
        //initLighting()
        

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
                tempLight.shadowColor = UIColor.black
                tempLight.isEnabled = true
                tempLight.categoryBitMask = LightCategory.Hero
                tempLight.zPosition = 11
                tempLight.position = CGPoint (x: 0, y: 0)
                
                
                //Add the new light to our lights array
                //roomLights.append(nil)
                roomLights[drawRoomIterator] = tempLight
                
                //Add the light as a child of level's (self) dungeon map
                //self.myDungeonMap.childNodeWithName(String(drawRoomIterator))?.addChild(roomLights[drawRoomIterator]!)
                
                //NOT WORKING!!!! TODO: ADD TO A NODE IN A RANDOM PART OF THE APPROPRIATE ROOM.
                
            } else {
                //Adding this to ensure lights index lines up with rooms index.
                //Eventually this should maybe be part of that struct
                //roomLights.append(nil)
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
        
        myHero.location.x = myDungeonMap.dungeonRooms[myDungeonMap.dungeonRooms.count - 1].location.x1+1
        myHero.location.y = myDungeonMap.dungeonRooms[myDungeonMap.dungeonRooms.count - 1].location.y1+1
        myHero.position = convertBoardCoordinatetoCGPoint(x: myHero.location.x, y: myHero.location.y)
        myHero.zPosition = 5
        self.addChild(myHero)
        
        
        //////////
        //Set the hero's light:
        //Note that ambient/falloff have issues in spritekit:
        //http://stackoverflow.com/questions/29828324/spritekit-sklightnode-falloff-property-has-no-effect
        heroTorch.lightColor = SKColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 0.7)
        heroTorch.isEnabled = false
        heroTorch.categoryBitMask = LightCategory.Hero
        heroTorch.zPosition = 52
        heroTorch.position = CGPoint (x: 0, y: 0)
        heroTorch.ambientColor = SKColor.red.withAlphaComponent(0.1)
            
        //NOTE: THESE ARE IMPORTANT; shadowColor drastically changes shit.
        //heroTorch.ambientColor = UIColor.redColor()
        heroTorch.falloff = 1
        heroTorch.shadowColor = SKColor.black.withAlphaComponent(0.7)
        
        myHero.addChild(heroTorch)
        
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
    

        // ADD ONE MONSTER IN EVERY ROOM
        for roomIterator in 0...myDungeonMap.dungeonRooms.count-1 {
            
            
            //Find a random coordinate within the room
            let roomWidth = myDungeonMap.dungeonRooms[roomIterator].location.x2 - myDungeonMap.dungeonRooms[roomIterator].location.x1 - 2
            let randXLocation = Int(arc4random_uniform(UInt32(roomWidth))) + myDungeonMap.dungeonRooms[roomIterator].location.x1 + 1
            let roomHeight = myDungeonMap.dungeonRooms[roomIterator].location.y2 - myDungeonMap.dungeonRooms[roomIterator].location.y1 - 2
            let randYLocation = Int(arc4random_uniform(UInt32(roomHeight))) + myDungeonMap.dungeonRooms[roomIterator].location.y1 + 1
            let randomDungeonLocation = DungeonLocation(x: randXLocation, y: randYLocation)

            
            //Add a monster to the dictionary
            monsterDictionary[randomDungeonLocation] = LivingThing.init(withThingType: KindsOfLivingThings.monster, atLocation: randomDungeonLocation)
            
            monsterDictionary[randomDungeonLocation]?.position = convertDungeonLocationtoCGPoint(dungeonLocation: randomDungeonLocation)
            
            //Set a somewhat random HP value on the MONSTER
            //monsterDictionary[randomDungeonLocation]?.hp = 100
            
            //Pick one of the six random monster images.
            //Eventually, this should be picking one of the random monster types (sub-classes or protocols)
            let randMonster = Int(arc4random_uniform(6)) + 1

            //Give monster some random look (here? Somewhere else?)
            monsterDictionary[randomDungeonLocation]?.texture = SKTexture(imageNamed: "monster_" + String(randMonster))
            monsterDictionary[randomDungeonLocation]?.size = SKTexture(imageNamed: "monster_" + String(randMonster)).size()
            
            //Add the MONSTER Sprite to the level
            self.addChild(monsterDictionary[randomDungeonLocation]!)
            
        }

        
        
        
        
        //////////
        //Set the SINGLE monsters
        aMonster.location.x = myDungeonMap.dungeonRooms[0].location.x1 + 1
        aMonster.location.y = myDungeonMap.dungeonRooms[0].location.y1 + 1
        aMonster.position = convertBoardCoordinatetoCGPoint(x: aMonster.location.x, y: aMonster.location.y)
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

        
    }
    
    
    
    
    //=====================================================================================================//
    // Return Tile information.
    // Given a tile location, return any object on top of it.
    //=====================================================================================================//

    func getTileContents(forTile: DungeonLocation){
        
        //search all mosters (array) for proper coordinates
        
        
        
        //return monsters or items or whatever shit is on the tile location.
    }
    
    
    
    
    
    //=====================================================================================================//
    // Return Room information -- doing this for debugging, but may be useful later
    //
    //=====================================================================================================//

    func getRoomDetailsForLocation (_ location: DungeonLocation) -> DungeonMap.DungeonRoom? {
        
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
    func getFurthestLocationFromLocation(_ sourceLocation: DungeonLocation) -> DungeonLocation {
        
        
        let furthestLocation: DungeonLocation = DungeonLocation(x: 1, y: 1)
        
        //Implement farthest (or furthest) path algorithm...
        
        return furthestLocation
    }
    
    
    
    
    func getClosestLocationToLocation(_ sourceLocation: DungeonLocation) -> DungeonLocation {
        
        let closestLocation: DungeonLocation = DungeonLocation(x: 1, y: 1)
        
        //Implement nearest path algorithm...
        
        return closestLocation
        
    }
    
    
    
    
    
}
