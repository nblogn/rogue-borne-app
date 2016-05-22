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


class LoadingView: SKNode {
    
    
    let loadingModal = SKShapeNode()
    
    
    func buildLoadingModal (parent: SKScene) {
        
        //Set the size of the loading modal
        let miniMapWidth = Int(parent.size.width / 4)
        let miniMapHeight = Int(parent.size.height / 4)
        let miniMapPositionX = Int(parent.size.width / 4)
        let miniMapPositionY = Int(parent.size.height / 4)
        
        loadingModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: miniMapWidth, height: miniMapHeight), cornerRadius: 8).CGPath
        loadingModal.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        loadingModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        loadingModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.5)
        loadingModal.lineWidth = 1
        loadingModal.glowWidth = 1
        loadingModal.zPosition = 200
        loadingModal.position = CGPoint(x: miniMapPositionX, y: miniMapPositionY)

        self.zPosition = 200
        
        
        
        //////////
        //Set the monster
        let texture = SKTexture(imageNamed: "RB_Monster1")
        let aMonster = SKSpriteNode(texture: texture, color: SKColor.clearColor(), size: texture.size())

        aMonster.position = CGPoint(x: 0, y: 0)
        
        self.addChild(aMonster)
        
        //Light the monster on fire
        if let particles = SKEmitterNode(fileNamed: "FireParticle.sks") {
            aMonster.addChild(particles)
        }

        
        
    }
    

    
    
    func showLoadingModal (parent: SKScene) {
        
        //If there's no parent, add this to parent and build
        if (loadingModal.parent == nil) {
            
            addChild(loadingModal)
            
            //If there ARE children in miniMapModal, don't rebuild the map. TODO: Update instead.
            if (loadingModal.children.count == 0) {
                buildLoadingModal(parent)
            }
            
            
        } else { //the button was clicked while the map was shown, so toggle it closed.
            hideLoadingModal()
        }
        
        
        
    }
    
    
    func hideLoadingModal () {
        
        loadingModal.removeFromParent()
        loadingModal.removeAllChildren()
        
    }
    
    
    
}