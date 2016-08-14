//
//  MiniMapView.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 5/19/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

class MiniMapView: SKSpriteNode {
    
    
    let miniMapModal = SKShapeNode()
    
    var miniMapVisible: Bool = false
    
    
    func buildMiniMapModalMinimalTiles (_ myDungeonMiniMap: DungeonMap, parent: SKScene) {
        
        //Set the size of the miniMap
        let miniMapWidth = miniTileSize.width * myDungeonMiniMap.dungeonSizeWidth + 5
        let miniMapHeight = miniTileSize.height * myDungeonMiniMap.dungeonSizeHeight + 5
        let miniMapPositionX = Int(parent.size.width / 2) - miniMapWidth - 30
        let miniMapPositionY = Int(parent.size.height / 2) - miniMapHeight - 30
        
        miniMapModal.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: miniMapWidth, height: miniMapHeight), cornerRadius: 8).cgPath
        miniMapModal.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        miniMapModal.strokeColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.5)
        miniMapModal.lineWidth = 1
        miniMapModal.glowWidth = 1
        miniMapModal.zPosition = 99
        miniMapModal.position = CGPoint(x: miniMapPositionX, y: miniMapPositionY)
        
        self.zPosition = 99


        //Build rooms as single rect nodes
        for roomIterator in 0...myDungeonMiniMap.dungeonRooms.count-1 {
            
            let coordinate1 = convertBoardCoordinatetoCGPoint(x: myDungeonMiniMap.dungeonRooms[roomIterator].location.x1, y: myDungeonMiniMap.dungeonRooms[roomIterator].location.y1, mini:true)
            
            let coordinate2 = convertBoardCoordinatetoCGPoint(x: myDungeonMiniMap.dungeonRooms[roomIterator].location.x2, y: myDungeonMiniMap.dungeonRooms[roomIterator].location.y2, mini: true)
            
            let width = coordinate2.x - coordinate1.x
            let height = coordinate2.y - coordinate1.y
            
            let room = SKShapeNode(rectOf: CGSize(width: width, height: height))
            room.fillColor = UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 0.8)
            room.strokeColor = UIColor(red: 0.9, green: 0.2, blue: 0.4, alpha: 0.8)
            room.lineWidth = 1
            room.glowWidth = 1
            room.zPosition = 100
            room.position = CGPoint(x: (coordinate1.x + CGFloat(width/2)), y:(coordinate1.y + CGFloat(height/2)))
            
            
            miniMapModal.addChild(room)
            
        }

        
        
        //Build hallways as single nodes
        for row in 0..<myDungeonMiniMap.dungeonMap.count {
            
            for column in 0..<myDungeonMiniMap.dungeonMap[row].count {

                let point = CGPoint(x: (column*miniTileSize.width), y: (row*miniTileSize.height))
                
                //Add mini corridors
                if (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.corridorHorizontal) || (myDungeonMiniMap.dungeonMap[row][column].tileType == Tile.corridorVertical) {
                    
                    let corridorShape = SKShapeNode(rectOf: CGSize(width: 3, height: 3))
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
    
    
    
    
    func updateMiniMapModal (miniDungeonLevel: DungeonLevel, parent: SKScene) {
        
        //iterate and find diffs, then move the diff
        
        //update hero
        let point = CGPoint(x: (miniDungeonLevel.myHero.location.x*miniTileSize.width), y: (miniDungeonLevel.myHero.location.y*miniTileSize.height))
        
        let heroShape = SKShapeNode(rectOf: CGSize(width: miniTileSize.width, height: miniTileSize.height))
        heroShape.fillColor = UIColor(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.7)
        heroShape.strokeColor = UIColor(red: 0.4, green: 1.0, blue: 0.1, alpha: 0.7)
        //corridorShape.lineWidth = 1
        heroShape.glowWidth = 1
        heroShape.zPosition = 100
        heroShape.position = point
        
        miniMapModal.addChild(heroShape)

    }
    
    
    
    
    //I'm doing too much code copying here from the DungeonMap class, but oh well...
    func showMiniMapModal (myDungeonMiniMap: DungeonLevel, parent: SKScene) {
        
        //If there's no parent, add this to parent and build
        if (miniMapModal.parent == nil) {
            
            addChild(miniMapModal)
            
            //If there ARE children in miniMapModal, don't rebuild the map. TODO: Update instead.
            if (miniMapModal.children.count == 0) {
                //buildMiniMapModal(myDungeonMiniMap, parent: parent)
                buildMiniMapModalMinimalTiles(myDungeonMiniMap.myDungeonMap, parent: parent)
                updateMiniMapModal(miniDungeonLevel: myDungeonMiniMap, parent: parent)
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
