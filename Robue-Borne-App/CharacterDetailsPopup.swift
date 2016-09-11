//
//  CharacterDetailsPopup.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/16/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

class CharacterDetailsPopup: SKNode {
    
    let detailsModal = SKShapeNode()
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // DETAILS -- Draw/hide the details modal popup window
    //
    //-------------------------------------------------------------------------------------------//
    func buildDetailsModalForNode (_ nodeToDetail: SKNode, parent: SKScene, dungeonLevel: DungeonLevel) {
                
        detailsModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 800, height: 550), cornerRadius: 8).cgPath
        detailsModal.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.8)
        detailsModal.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.8)
        detailsModal.lineWidth = 5
        detailsModal.glowWidth = 2
        detailsModal.zPosition = 99
        detailsModal.position = CGPoint(x: (-(parent.size.width/2) + 375), y:(-(parent.size.height/2) + 100))
        
        self.zPosition = 99
        
        let exitButton = GenericRoundSpriteButtonWithName("exitButton", text: "Exit")
        exitButton.position = CGPoint (x: 50, y: 50)
        
        detailsModal.addChild(exitButton)
        
        
        //Ensure the node we touched is a LivingThing
        if nodeToDetail.isKind(of: LivingThing.self) {
            
            
            //Force-cast generic SKNode into the LivingThing type
            let livingThingToDetail = nodeToDetail as! LivingThing
            
            
            /////////////////
            //Hero details
            if (livingThingToDetail.thingType == .hero) || (livingThingToDetail.thingType == .monster) {

                //debug
                print("touchedNode is a Hero or Monster")
                print(nodeToDetail)
                print(livingThingToDetail.hitPoints)
                print("livingThingToDetail Location:", livingThingToDetail.getCurrentLocation())
                ///debug
                
                let stats: String = livingThingToDetail.getStats()
                
                let location: DungeonLocation = livingThingToDetail.getCurrentLocation()
                
                let memText = GenericText.init(name: "statsText", text: stats)
                memText.position = CGPoint(x: 150, y: 450)
                
                let roomInfoText = dungeonLevel.getRoomDetailsForLocation(location)?.roomType
                
                let dungeonRoomText: GenericText
                
                if roomInfoText != nil {
                    dungeonRoomText = GenericText.init(name: "hi", text: String("Room: "+roomInfoText!))
                } else {
                    dungeonRoomText = GenericText.init(name: "hi", text: "Not in a room!")
                }
                
                dungeonRoomText.position = CGPoint(x: 150, y:400)
                
                detailsModal.addChild(memText)
                detailsModal.addChild(dungeonRoomText)
                
            } else {
                //In case I want a different view for Monsters or something
            }
            

        /////////////////
        //Not a living thing
        } else {
            //Do nothing, but might want to detail other shit later
            //...Such as items
            //...or even just generic shit, like "hey, this is a piece of dirt"
        }
        
    }
    
    
    
    //Show the model, build if needed...
    func showDetailsModalForNode (_ nodeToDetail: SKNode, parent: SKScene, dungeonLevel: DungeonLevel) {
        
        //If there's no parent, add this to parent (note, it's already added in PlayScene)
        if (detailsModal.parent == nil) {
            self.addChild(detailsModal)
            
            if (detailsModal.children.count == 0) {
                buildDetailsModalForNode(nodeToDetail, parent: parent, dungeonLevel: dungeonLevel)
            }
        } else { //toggle OFF
            hideDetailsModal()
        }
    }
    

    
    func hideDetailsModal () {

        //remove details window
        detailsModal.removeFromParent()
        detailsModal.removeAllChildren()

    }

    
    
}
