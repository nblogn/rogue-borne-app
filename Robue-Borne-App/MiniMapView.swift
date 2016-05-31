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
    
    
    func buildMiniMapModal (myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        //Set the size of the miniMap
        let miniTileSize = 3
        let miniMapWidth = miniTileSize * myDungeonMiniMap.dungeonSizeWidth + 5
        let miniMapHeight = miniTileSize * myDungeonMiniMap.dungeonSizeHeight + 5
        let miniMapPositionX = Int(parent.size.width / 2) - miniMapWidth - 30
        let miniMapPositionY = Int(parent.size.height / 2) - miniMapHeight - 30
        
        miniMapModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: miniMapWidth, height: miniMapHeight), cornerRadius: 8).CGPath
        miniMapModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        miniMapModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.5)
        miniMapModal.lineWidth = 1
        miniMapModal.glowWidth = 1
        miniMapModal.zPosition = 99
        miniMapModal.position = CGPoint(x: miniMapPositionX, y: miniMapPositionY)
        
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

    
    
    func buildMiniMapModalMinimalTiles (myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        //Set the size of the miniMap
        let miniMapWidth = miniTileSize.width * myDungeonMiniMap.dungeonSizeWidth + 5
        let miniMapHeight = miniTileSize.height * myDungeonMiniMap.dungeonSizeHeight + 5
        let miniMapPositionX = Int(parent.size.width / 2) - miniMapWidth - 30
        let miniMapPositionY = Int(parent.size.height / 2) - miniMapHeight - 30
        
        miniMapModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: miniMapWidth, height: miniMapHeight), cornerRadius: 8).CGPath
        miniMapModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        miniMapModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.5)
        miniMapModal.lineWidth = 1
        miniMapModal.glowWidth = 1
        miniMapModal.zPosition = 99
        miniMapModal.position = CGPoint(x: miniMapPositionX, y: miniMapPositionY)
        
        self.zPosition = 99


        //Build rooms as single rect nodes
        for roomIterator in 0...myDungeonMiniMap.dungeonRooms.count-1 {
            
            let coordinate1 = convertBoardCoordinatetoCGPoint(myDungeonMiniMap.dungeonRooms[roomIterator].location.x1, y: myDungeonMiniMap.dungeonRooms[roomIterator].location.y1, mini:true)
            
            let coordinate2 = convertBoardCoordinatetoCGPoint(myDungeonMiniMap.dungeonRooms[roomIterator].location.x2, y: myDungeonMiniMap.dungeonRooms[roomIterator].location.y2, mini: true)
            
            let width = coordinate2.x - coordinate1.x
            let height = coordinate2.y - coordinate1.y
            
            let room = SKShapeNode(rectOfSize: CGSize(width: width, height: height))
            room.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 0.8)
            room.strokeColor = UIColor(red: 0.9, green: 0.2, blue: 0.4, alpha: 0.8)
            room.lineWidth = 1
            room.glowWidth = 1
            room.zPosition = 100
            room.position = CGPoint(x: (coordinate1.x + CGFloat(width/2)), y:(coordinate1.y + CGFloat(height/2)))
            
            
            miniMapModal.addChild(room)
            
        }

        
        
        //Build hallways as single nodes using
        for row in 0..<myDungeonMiniMap.dungeonMap.count {
            
            for column in 0..<myDungeonMiniMap.dungeonMap[row].count {

                let point = CGPoint(x: (column*miniTileSize.width), y: (row*miniTileSize.height))
                
                //Add mini corridors
                if (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.CorridorHorizontal) || (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.CorridorVertical) {
                    
                    let corridorShape = SKShapeNode(rectOfSize: CGSize(width: 3, height: 3))
                    corridorShape.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.1, alpha: 0.7)
                    //corridorShape.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
                    //corridorShape.lineWidth = 1
                    //corridorShape.glowWidth = 1
                    corridorShape.zPosition = 100
                    corridorShape.position = point
                    
                    miniMapModal.addChild(corridorShape)
                    
                }
                
            }
            
        }
        
    
    }
    
    
    func covertDungeonCoordinateToMiniMap (coordinate: CGPoint) {
        
        
        
    }
    
    
    
    
    func updateMiniMapModal (myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        //iterate and find diffs, then move the diff
        
    }
    
    
    
    
    //I'm doing too much code copying here from the DungeonMap class, but oh well...
    func showMiniMapModal (myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        //If there's no parent, add this to parent and build
        if (miniMapModal.parent == nil) {
            
            addChild(miniMapModal)
            
            //If there ARE children in miniMapModal, don't rebuild the map. TODO: Update instead.
            if (miniMapModal.children.count == 0) {
                //buildMiniMapModal(myDungeonMiniMap, parent: parent)
                buildMiniMapModalMinimalTiles(myDungeonMiniMap, parent: parent)
            }
            
            
        } else { //the button was clicked while the map was shown, so toggle it closed.
            hideMiniMapModal()
        }
        
        

    }
    
    
    func hideMiniMapModal () {

        miniMapModal.removeFromParent()
        miniMapModal.removeAllChildren()
        
    }
    
    
    
}