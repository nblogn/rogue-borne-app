//
//  CombatCoordinator.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 8/2/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


class CombatCoordinator {

    
    init() {
        //nothing right now
    }
    

    
    
    //------------------------------------------- doTurn ----------------------------------------//
    //
    // Coordinates all things that happen in a turn
    //
    //  Move the hero
    //  for each monster (within range? And not sleeping?)
    //      Can the hero attack?
    //      Can the monsters attach?
    //
    //-------------------------------------------------------------------------------------------//

    func doTurn (heroTurnAction: HeroAction, dungeonLevel: DungeonLevel) -> Void {
        
        //Hero's turn
        switch heroTurnAction {
        case let .moveBy(amount):
            moveHeroBy(byAmount: amount, dungeonLevel: dungeonLevel)
        default:
            break
        }
        
        //Monsters' turn
        moveMonsters(dungeonLevel: dungeonLevel)
        
    }
    
    

    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Move the hero
    //
    //-------------------------------------------------------------------------------------------//
    
    //This moves the hero one turn by the amount given (right now, +1 in the direction pushed)
    private func moveHeroBy(byAmount:DungeonLocation, dungeonLevel: DungeonLevel) {
        
        
        let newLocationToMoveTo = DungeonLocation(x: (dungeonLevel.myHero.location.x + byAmount.x), y: (dungeonLevel.myHero.location.y + byAmount.y))
        
        switch dungeonLevel.myDungeonMap.dungeonMap[dungeonLevel.myHero.location.y + byAmount.y][dungeonLevel.myHero.location.x + byAmount.x].tileType {
            
        case .door, .corridorHorizontal, .corridorVertical, .grass, .ground:
            
            print("New her location to move to:", newLocationToMoveTo)
            print("Hash of new hero location to move to:", newLocationToMoveTo.hashValue)
            //Check for monster! If no Monster at this point in dictionary move, else heroMeleeAttack()
            if (dungeonLevel.monsterDictionary[newLocationToMoveTo] == nil) {
  
                //Figure out new hero location/position
                dungeonLevel.myHero.location.x = dungeonLevel.myHero.location.x + byAmount.x
                dungeonLevel.myHero.location.y = dungeonLevel.myHero.location.y + byAmount.y
                let xyPointDiff = convertBoardCoordinatetoCGPoint(x: dungeonLevel.myHero.location.x, y:dungeonLevel.myHero.location.y)
                
                //Move the background for parallax effect:
                let newBackgroundX = dungeonLevel.dungeonBackground.position.x + (CGFloat(tileSize.width) * CGFloat(byAmount.x)*0.5)
                let newBackgroundY = dungeonLevel.dungeonBackground.position.y + (CGFloat(tileSize.height) * CGFloat(byAmount.y)*0.35)
                let newDungeonBackgroundPosition = CGPoint(x: newBackgroundX, y: newBackgroundY)
                
                //Run the actions; do I need to group these to do in parallel???
                dungeonLevel.dungeonBackground.run(SKAction.move(to: newDungeonBackgroundPosition, duration: 0.1))
                dungeonLevel.myHero.run(SKAction.move(to: xyPointDiff, duration: 0.1))

            } else {

                //Fight the monster the player tried to move into
                heroMeleeAttack(attackLocation: newLocationToMoveTo, dungeonLevel: dungeonLevel)
            }
            
            
        default: break
        }
        
    }
    
    
    //This moves to a target location, !!one turn at a time!!
    //For eventual fast travel and auto-exploration.
    private func moveHeroTo(destination: DungeonLocation, dungeonLevel: DungeonLevel) {
        
        
    }

    
    //Teleport moves a long distance in ONE turn.
    private func teleportHero(x:Int, y:Int, dungeonLevel: DungeonLevel) {
        
        
    }

    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // Hero attacks
    //
    //-------------------------------------------------------------------------------------------//

    private func heroMeleeAttack(attackLocation: DungeonLocation, dungeonLevel: DungeonLevel) {
        
        
        let victim = dungeonLevel.monsterDictionary[attackLocation]!
        
        //attackCalculator(attackType, victim)
        
        victim.hit(hpLost: 1)
        
        
    }
    
    //maybe heroAttack

    private func heroRangedAttack () {
        
    }
    
    
    private func heroScript() {
        
    }
    
    
    
    

    //-------------------------------------------------------------------------------------------//
    //
    // Move the monsters
    //
    //-------------------------------------------------------------------------------------------//
    
    private func moveMonsters(dungeonLevel: DungeonLevel) -> Void {
    
        //let monster:
        
        for monster in dungeonLevel.monsterDictionary {
            
            //if in range of attack, including hallways
            
            //Else
            
                //if in same room...
                    //if within the range that the monster can see/sense -- TODO later
                        //Monster starts attack AI
                //else move randomly or rest
            
            
                    moveMonsterRandomDirection(dungeonLevel: dungeonLevel, monsterToMove: monster.value)
            
        }
    
    }
    
    
    
    
    private func moveMonsterRandomDirection(dungeonLevel: DungeonLevel, monsterToMove: LivingThing) -> Void {
        // Let's just move randomly for now.
        // Pick a cardinal direction and check for collision
        // Repeat until a successful move has occurred or
        // the number of tries reaches 5. Dude could be trapped
        // like a Piner in a closet and we don't want to hang
        // JOSH: LOL!
        
        var hasMoved: Bool=false
        var numTries: Int=0
        var direction: Int
        
        //remove the about to be moved monster from the location dictionary, we'll update after we've moved...
        dungeonLevel.monsterDictionary.removeValue(forKey: monsterToMove.location)

        while ( hasMoved == false ) && ( numTries < 5) {
            
            direction = Int(arc4random_uniform(4))
            
            
            switch direction {
            case 0:
                // Try north
                if isValidMove(dungeonLevel: dungeonLevel, locationToCheck: DungeonLocation(x: monsterToMove.getCurrentLocation().x, y: monsterToMove.getCurrentLocation().y-1)) {

                    monsterToMove.setCurrentLocation(monsterToMove.getCurrentLocation().x, Y: monsterToMove.getCurrentLocation().y-1)
                    hasMoved = true
                }

                
            case 1:
                // Try south
                if isValidMove(dungeonLevel: dungeonLevel, locationToCheck: DungeonLocation(x: monsterToMove.getCurrentLocation().x, y: monsterToMove.getCurrentLocation().y+1)) {

                    monsterToMove.setCurrentLocation(monsterToMove.getCurrentLocation().x, Y: monsterToMove.getCurrentLocation().y+1)
                    hasMoved = true
                    
                }

                
            case 2:
                // Try east
                if isValidMove(dungeonLevel: dungeonLevel, locationToCheck: DungeonLocation(x: monsterToMove.getCurrentLocation().x-1, y: monsterToMove.getCurrentLocation().y)) {

                    monsterToMove.setCurrentLocation(monsterToMove.getCurrentLocation().x-1, Y: monsterToMove.getCurrentLocation().y)
                    hasMoved = true
                }

                
            case 3:
                // Try west
                if isValidMove(dungeonLevel: dungeonLevel, locationToCheck: DungeonLocation(x: monsterToMove.getCurrentLocation().x+1, y: monsterToMove.getCurrentLocation().y)) {

                    monsterToMove.setCurrentLocation(monsterToMove.getCurrentLocation().x+1, Y: monsterToMove.getCurrentLocation().y)
                    hasMoved = true
                }
                    

            default:
                
                print("Fell through monster move switch")
            }
            
            numTries += 1
        }
        
        
        //Add the monster back into the dictionary at the new location...
        dungeonLevel.monsterDictionary[monsterToMove.location] = monsterToMove

        //Do the visual move...
        let xyPointDiff = convertBoardCoordinatetoCGPoint(x: monsterToMove.location.x, y: monsterToMove.location.y)
        monsterToMove.run(SKAction.move(to: xyPointDiff, duration: 0.1))
        
        
    }//moveMonster()

    
    
    //Thinking this should work with spritenode's physics function. EG, make the walls have physics.
    private func isValidMove(dungeonLevel: DungeonLevel, locationToCheck: DungeonLocation) -> Bool {
        
        if (dungeonLevel.myHero.location != locationToCheck) && (dungeonLevel.monsterDictionary[locationToCheck]==nil) {
            
            switch dungeonLevel.myDungeonMap.dungeonMap[locationToCheck.y][locationToCheck.x].tileType {
                case .door, .corridorHorizontal, .corridorVertical, .grass, .ground:
                    return true
                default:
                    return false
            }
            
        } else {
            return false
        }
        
    }
    
    private func isLocationWithinRangeOfAttack() -> Bool {
        return false
    }

    
    private func monsterAttack() -> Void {
        
        
        
    }
    
    
    private func attackCalculator() -> Void {
        
    }
    
}
