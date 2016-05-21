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
    
    
    
    
    
    
    //I'm doing too much code copying here from the DungeonMap class, but oh well...
    func showMiniMapModal (myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        self.moveToParent(parent)
        
        
        
        //Set the size of the miniMap
        let miniTileSize = 3
        let miniMapWidth = miniTileSize * myDungeonMiniMap.dungeonSizeWidth + 5
        let miniMapHeight = miniTileSize * myDungeonMiniMap.dungeonSizeHeight + 5
        let miniMapPositionX = Int(parent.size.width) - miniMapWidth - 30
        let miniMapPositionY = Int(parent.size.height) - miniMapHeight - 40
        
        miniMapModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: miniMapWidth, height: miniMapHeight), cornerRadius: 8).CGPath
        miniMapModal.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        miniMapModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        miniMapModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.5)
        miniMapModal.lineWidth = 1
        miniMapModal.glowWidth = 1
        miniMapModal.zPosition = 99
        miniMapModal.position = CGPoint(x: miniMapPositionX, y: miniMapPositionY)
        addChild(miniMapModal)
        
        self.zPosition = 99

        
    
        
        for row in 0..<myDungeonMiniMap.dungeonMap.count {
            
            for column in 0..<myDungeonMiniMap.dungeonMap[row].count {
                
                
                //Let's skip the "nothing" tiles
                if (myDungeonMiniMap.dungeonMap[row][column].tileType != Tile.Nothing) {

                    
                    //Calculate the current position
                    //Note: in the SpriteKit coordinate system, Y values increase as you move up the screen and decrease as you move down.
                    
                    let point = CGPoint(x: (column*miniTileSize+2), y: (row*miniTileSize+2))
                    
                    
                    //Add mini walls
                    if (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.Wall) || (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.Nothing) {

                        let wallShape = SKShapeNode(rectOfSize: CGSize(width: 3, height: 3))
                        wallShape.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
                        wallShape.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
                        wallShape.lineWidth = 1
                        wallShape.glowWidth = 1
                        wallShape.zPosition = 100
                        wallShape.position = point
                        
                        miniMapModal.addChild(wallShape)
                        
                    }
                    
                    
                    //Add mini corridors
                    if (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.CorridorHorizontal) || (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.CorridorVertical) {

                        let corridorShape = SKShapeNode(rectOfSize: CGSize(width: 3, height: 3))
                        corridorShape.fillColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 0.7)
                        corridorShape.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
                        corridorShape.lineWidth = 1
                        corridorShape.glowWidth = 1
                        corridorShape.zPosition = 100
                        corridorShape.position = point
                        
                        miniMapModal.addChild(corridorShape)
                    }
                    
                    
                    //Add mini floors
                    if (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.Ground) {
                        
                        let groundShape = SKShapeNode(rectOfSize: CGSize(width: 3, height: 3))
                        groundShape.fillColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 0.7)
                        groundShape.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
                        groundShape.lineWidth = 1
                        groundShape.glowWidth = 1
                        groundShape.zPosition = 100
                        groundShape.position = point
            
                        miniMapModal.addChild(groundShape)
                    }
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