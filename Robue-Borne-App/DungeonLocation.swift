//
//  DungeonLocation.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 8/31/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit



//Making this hashable/equatable (req'd when hashable) to ensure we can map it (dictionary) for quick retreval later.
//EG: Give me all the items at a given/specific DungeonLocation
struct DungeonLocation: Hashable {
    
    var x: Int
    var y: Int
    
    var hashValue: Int {
        let hashString = (String(self.x)+","+String(self.y))
        return hashString.hashValue
    }
    
    static func == (lhs: DungeonLocation, rhs: DungeonLocation) -> Bool {
        
        let dungeonLocationComp: Bool
        
        if (lhs.x == rhs.x) && (lhs.y == rhs.y) {
            dungeonLocationComp = true
        } else {
            dungeonLocationComp = false
        }
        
        return dungeonLocationComp
    }
    
    //Returns the DungeonLocation from a key of String, or nil if nonexistent
    func getLocationFromKey(key: String) -> DungeonLocation? {
        
        let rangeOfComma = key.range(of: ",", options: NSString.CompareOptions.backwards)
        
        var xTemp: Int = -1
        var yTemp: Int = -1
        
        
        //Get X
        if (rangeOfComma != nil) {
            // Found a comma, get the following text
            xTemp = Int(String(key.characters.prefix(upTo: rangeOfComma!.lowerBound)))!
        }

        //Get y
        if (rangeOfComma != nil) {
            // Found a comma, get the following text
            yTemp = Int(String(key.characters.suffix(from: rangeOfComma!.upperBound)))!
        }
        
        if (xTemp == -1) {
            return nil
        } else {
            return DungeonLocation(x:xTemp, y:yTemp)
        }

    }
    
    //Creates a string for a dictionary key eg: (1,2) becomes "1,2"
    func createKeyFromLocation() -> String {
        return String(String(self.x)+","+String(self.y))
    }

}



//-------------------------------------------------------------------------------------------//
//Handling board coordinate space
//Given a board position (or, preferably, a DungeonLocation) convert to CGPoint
//-------------------------------------------------------------------------------------------//
func convertBoardCoordinatetoCGPoint (x: Int, y: Int, mini: Bool = false) -> CGPoint {
    
    let retX: Int
    let retY: Int
    
    if mini == true {
        
        retX = x * miniTileSize.width
        retY = y * miniTileSize.height
        
    } else {
        
        retX = x * tileSize.width
        retY = y * tileSize.height
        
    }
    
    return CGPoint(x: retX, y: retY)
    
}


func convertDungeonLocationtoCGPoint (dungeonLocation: DungeonLocation, mini: Bool = false) -> CGPoint {
    
    let retX: Int
    let retY: Int
    
    if mini == true {
        
        retX = dungeonLocation.x * miniTileSize.width
        retY = dungeonLocation.y * miniTileSize.height
        
    } else {
        
        retX = dungeonLocation.x * tileSize.width
        retY = dungeonLocation.y * tileSize.height
        
    }
    
    return CGPoint(x: retX, y: retY)
    
}


