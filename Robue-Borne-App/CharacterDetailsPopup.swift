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
    func showDetailsModalForNode <T where T: basicCharacterAbilities> (nodeToDetail: T, parent: SKScene) {
        
        self.moveToParent(parent)
        
        detailsModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 700, height: 650), cornerRadius: 8).CGPath
        detailsModal.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        detailsModal.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        detailsModal.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        detailsModal.lineWidth = 10
        detailsModal.glowWidth = 5
        detailsModal.zPosition = 99
        detailsModal.position = CGPoint(x: 285, y:50)
        addChild(detailsModal)
                
        self.zPosition = 99
        
        let exitButton = GenericRoundButtonWithName("exitButton", text: "Exit")
        exitButton.position = CGPoint (x: 50, y: 20)
        
        detailsModal.addChild(exitButton)
        
        
        //TODO: lookup the details nodeToDetail and print out details!
        let stats: String = nodeToDetail.getStats()
        
        self.addChild(GenericText.init(name: "statsText", text: stats))
        
    }
    
    func hideDetailsModal () {
        //remove details window
        self.removeFromParent()
        
        //Don't think I need this...
        //detailsModal.removeFromParent()
    }

    
    
}