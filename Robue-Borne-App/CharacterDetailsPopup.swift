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
    func buildDetailsModalForNode (nodeToDetail: SKNode, parent: SKScene, dungeonLevel: DungeonLevel) {
                
        detailsModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 700, height: 650), cornerRadius: 8).CGPath
        detailsModal.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        detailsModal.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        detailsModal.lineWidth = 10
        detailsModal.glowWidth = 5
        detailsModal.zPosition = 99
        detailsModal.position = CGPoint(x: (-(parent.size.width/2) + 200), y:(-(parent.size.height/2) + 50))
        
        self.zPosition = 99
        
        let exitButton = GenericRoundButtonWithName("exitButton", text: "Exit")
        exitButton.position = CGPoint (x: 50, y: 20)
        
        detailsModal.addChild(exitButton)
        

        if nodeToDetail.isKindOfClass(Hero) {
            
            
            print("touchedNode is a Hero")
            print (nodeToDetail)
            
            //Force cast nodeToDetail to Hero (from SKNode)
            let temp = nodeToDetail as! Hero
            let stats: String = temp.getStats()
            
            let location: dungeonLocation = temp.getCurrentLocation()
            
            let memText = GenericText.init(name: "statsText", text: stats)
            memText.position = CGPoint(x: 150, y: 450)
            
            
            
            
            let roomInfoText = dungeonLevel.getRoomDetailsForLocation(location)?.type
            
            let dungeonRoomText: GenericText
            
            if roomInfoText != nil {
                dungeonRoomText = GenericText.init(name: "hi", text: roomInfoText!)
            } else {
                dungeonRoomText = GenericText.init(name: "hi", text: "Not in a room!")
            }
            
            dungeonRoomText.position = CGPoint(x: 150, y:400)
            
            
            detailsModal.addChild(memText)
            detailsModal.addChild(dungeonRoomText)
            
            print(temp.hitPoints)

        
        
        } else if nodeToDetail.isKindOfClass(Monster) {
            
        }
        
    }
    
    
    //Show the model, build if needed...
    func showDetailsModalForNode (nodeToDetail: SKNode, parent: SKScene, dungeonLevel: DungeonLevel) {
        
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