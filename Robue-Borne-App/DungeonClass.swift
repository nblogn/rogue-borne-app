//
//  DungeonClass.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation


//============================================================//
//
//: Rogueborne (working title) playground
//: A playground to try out my board gen ideas for Rogueborne
//
//============================================================//


//============================================================//
//
// Build level map via Arrays
//
//============================================================//

import Darwin


//Create a class for a "thing" that is in a certain dungeon tile
class dungeonTileObject {
    
    let floor:String = "."
    let wall:String = "="
    let vwall:String = "|"
    let nothing:String = " "
    
    //Would monsters, or people inherit from this class?
}


class Dungeon {
    

    //Constants and initializers
    let dungeonSizeWidth = 180
    let dungeonSizeHeight = 50
    let cellSizeHeight = 15
    let cellSizeWidth = 15
    let floor:String = "."
    let wall:String = "="
    let vwall:String = "|"
    let nothing:String = " "

    
    struct dungeonRoomLocation {
        var x1: Int = 0
        var y1: Int = 0
        var x2: Int = 0
        var y2: Int = 0
    }

    
    
    init () {


        //create a default row for the dungeon, with "nothing" in each tile...
        var myDungeonDefaultRow = [String](count:dungeonSizeWidth, repeatedValue:nothing)
        
    }



    //============================================================//
    //create random rooms with max cell size...
    //============================================================//
    func createRooms() -> [[String]]{
        
        ////
        //loop through by CELL ROWs and create random rooms stored within an array of room locations.
        //I might want to consider keeping this array for later use, right now I'm throwing it away.
        //Maybe as part of the dungeon object (which will eventually be more than a string).
        ////
        
        //Calculate number of cells based on dungeon size
        let numberOfCellsHeight = dungeonSizeHeight / cellSizeHeight
        let numberOfCellsWidth = dungeonSizeWidth / cellSizeWidth
        var numberOfCells =  numberOfCellsHeight * numberOfCellsWidth
        
        //Create some max offsets
        let maxOffsetX: UInt32 = (UInt32(cellSizeWidth) / 2) - 2
        let maxOffsetY: UInt32 = (UInt32(cellSizeHeight) / 2) - 2
        
        //Init the dungeon cells
        var dungeonRooms = [dungeonRoomLocation]()
        var tempDungeonRoom = dungeonRoomLocation()
        
        //Other inits
        var numberOfHeightCellsIterator = 0
        var numberOfWidthCellsIterator = 0
        var rowIterator=0
        var columnIterator=0
        var randX1_Offset = 0
        var randX2_Offset = 0
        var randY1_Offset = 0
        var randY2_Offset = 0
        
        while numberOfHeightCellsIterator < numberOfCellsHeight {
            
            while numberOfWidthCellsIterator < numberOfCellsWidth {
                
                //Randomly decide if this cell should have a room
                let shouldICreateARoomInThisCell = Int(arc4random_uniform(2))
                if shouldICreateARoomInThisCell == 1 {
                    
                    //create a random offset for all directions
                    randX1_Offset = Int(arc4random_uniform(maxOffsetX))
                    randX2_Offset = Int(arc4random_uniform(maxOffsetX))
                    randY1_Offset = Int(arc4random_uniform(maxOffsetY))
                    randY2_Offset = Int(arc4random_uniform(maxOffsetY))
                    
                    
                    //create cell locations with random offsets
                    tempDungeonRoom.x1 = columnIterator + randX1_Offset
                    tempDungeonRoom.x2 = columnIterator + cellSizeWidth - randX2_Offset
                    tempDungeonRoom.y1 = rowIterator + randY1_Offset
                    tempDungeonRoom.y2 = rowIterator + cellSizeHeight - randY2_Offset
                    
                    dungeonRooms.append(tempDungeonRoom)
                    
                }
                
                columnIterator += cellSizeWidth
                numberOfWidthCellsIterator++
            }
            
            columnIterator = 0
            numberOfWidthCellsIterator = 0
            rowIterator += cellSizeHeight
            numberOfHeightCellsIterator++
        }
        
        
        ////
        //Now that I have the array of room locations, I will draw the rooms into the dungeon array.
        ////
        
        //Temp dungeon to be returned
        var generatedDungeon = [[String]](count: dungeonSizeHeight, repeatedValue:myDungeonDefaultRow)
        
        //Reset the loopers
        numberOfHeightCellsIterator = 0
        numberOfWidthCellsIterator = 0
        rowIterator=0
        columnIterator=0
        var roomX1 = 0
        var roomY1 = 0
        var roomX2 = 0
        var roomY2 = 0
        var roomWidth = 0
        var roomHeight = 0
        
        //debug:
        numberOfCells = dungeonRooms.count
        var numberOfCellsIterator = 0
        
        //Actually draw the rooms in the dungeons array
        while numberOfCellsIterator < numberOfCells{
            
            
            roomX1 = dungeonRooms[numberOfCellsIterator].x1
            roomY1 = dungeonRooms[numberOfCellsIterator].y1
            roomX2 = dungeonRooms[numberOfCellsIterator].x2
            roomY2 = dungeonRooms[numberOfCellsIterator].y2
            
            roomHeight = roomY2 - roomY1
            roomWidth = roomX2 - roomX1
            
            while rowIterator < roomHeight {
                
                while columnIterator < roomWidth {
                    
                    //if top or bottom of room, fill with all walls, else, floor
                    if (rowIterator == 0) || (rowIterator == roomHeight-1) {
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = wall
                    }
                    else if (columnIterator == 0) || (columnIterator == roomWidth-1) {
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = vwall
                    }
                    else {
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = floor
                    }
                    columnIterator++
                    
                }
                
                columnIterator = 0
                rowIterator++
                
            }
            
            rowIterator = 0
            columnIterator = 0
            
            numberOfCellsIterator++
            
        }
        
        
        //Finally, return the full generated dungeon
        return generatedDungeon
        
    }




    //============================================================//
    // Print a 2D array
    //============================================================//
    func printDungeon(mazeToPrint: [[String]]){
        
        for var row = 0; row < mazeToPrint.count; row++ {
            for var column = 0; column < mazeToPrint[row].count; column++ {
                print("\(mazeToPrint[row][column])", terminator:"")
            }
            print(" - \(row)")
        }
        
    }

}

/*
//Actually run the shit...

//create a default dungeon of default rows of "nothing" in each tile...
var myDungeon = [[String]](count: dungeonSizeHeight, repeatedValue:myDungeonDefaultRow)

myDungeon = createRooms()

print2dArray(myDungeon)

*/
