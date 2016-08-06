//
//  LoadingView.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 5/21/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
//
//  MiniMapView.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 5/19/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


class LoadingNode: SKNode {
    
    
    let loadingModal = SKShapeNode()
    
    
    func buildLoadingModal (parent: SKScene) {
        
        //Set the size of the loading modal
        let loadingModalWidth = Int(parent.size.width)
        let loadingModalHeight = Int(parent.size.height)
        let loadingModalPositionX = 0 //-Int(parent.size.width / 4)
        let loadingModalPositionY = 0 //-Int(parent.size.height / 4)
        
        loadingModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: loadingModalWidth, height: loadingModalHeight), cornerRadius: 8).cgPath
        loadingModal.position = CGPoint(x: frame.midX, y: frame.midY)
        loadingModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        loadingModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1)
        loadingModal.lineWidth = 1
        loadingModal.glowWidth = 1
        loadingModal.zPosition = 200
        loadingModal.position = CGPoint(x: loadingModalPositionX, y: loadingModalPositionY)
    
        self.zPosition = 200
        
        
        
        //////////
        //Set the monster
        let texture = SKTexture(imageNamed: "RB_Monster1")
        let aMonster = SKSpriteNode(texture: texture, color: SKColor.clear, size: CGSize(width: Int(loadingModalWidth - 20), height: Int(loadingModalHeight-20)))

        aMonster.position = CGPoint(x: Int(loadingModalWidth/2), y: Int(loadingModalHeight/2))
        
        loadingModal.addChild(aMonster)
        
        //Light the monster on fire
        if let particles = SKEmitterNode(fileNamed: "FireParticle.sks") {
            aMonster.addChild(particles)
        }

        
        
    }
    

    
    
    func showLoadingModal (_ parent: SKScene) {
        
        //If there's no parent, add this to parent and build
        if (loadingModal.parent == nil) {
            
            self.addChild(loadingModal)
            
            //If there ARE children in modal, don't rebuild the modal. TODO: Update instead.
            if (loadingModal.children.count == 0) {
                buildLoadingModal(parent: parent)
            }
            
            
        } else { //the button was clicked while the map was shown, so toggle it closed.
            hideLoadingModal()
        }
        
        
        
    }
    
    
    func hideLoadingModal () {
        
        self.run(SKAction.fadeOut(withDuration: 0.5))
        
        loadingModal.removeFromParent()
        loadingModal.removeAllChildren()
        self.removeFromParent()
    }
    
    
    
}
