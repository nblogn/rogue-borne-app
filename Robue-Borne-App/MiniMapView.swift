//
//  MiniMapView.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 5/19/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

class MiniMapView: SKNode {
    
    
    let miniMapModal = SKShapeNode()
    

    
    func showMiniMapModal (myDungeonMiniMap: [[TileClass]], parent: SKScene) {
        
        self.moveToParent(parent)
        
        miniMapModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 700, height: 650), cornerRadius: 8).CGPath
        miniMapModal.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        miniMapModal.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        miniMapModal.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        miniMapModal.lineWidth = 2
        miniMapModal.glowWidth = 2
        miniMapModal.zPosition = 99
        miniMapModal.position = CGPoint(x: 600, y:500)
        addChild(miniMapModal)
        
        self.zPosition = 99

        
            
        for row in 0..<myDungeonMiniMap.count {
            
            for column in 0..<myDungeonMiniMap[row].count {

                
                let shape = SKShapeNode(rectOfSize: CGSize(width: 300, height: 100))
                shape.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
                shape.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
                shape.lineWidth = 1
                shape.glowWidth = 1
                shape.zPosition = 100
                addChild(shape)

                
                
                //Stack each tileSprite in a grid, left to right, then top to bottom. Note: in the SpriteKit coordinate system,
                //y values increase as you move up the screen and decrease as you move down.
                let point = CGPoint(x: (column*tileSize.width), y: (row*tileSize.height))
                
                
                //Make walls and "nothing" cast shadows
                if (myDungeonMiniMap[row][column].tileType == Tile.Wall) || (myDungeonMiniMap[row][column].tileType == Tile.Nothing) {

                }
                
                //Let's not add the "nothing" tiles, they hit the CPU way too much...
                if (myDungeonMiniMap[row][column].tileType != Tile.Nothing) && (myDungeonMiniMap[row][column].tileType != Tile.Ground) {
                    
                }
                
                
            }
            
        }
        
    }
    
    
    func hideMiniMapModal () {
        //remove details window
        self.removeFromParent()
        
        //Don't think I need this...
        //detailsModal.removeFromParent()
    }
    
    
    
}