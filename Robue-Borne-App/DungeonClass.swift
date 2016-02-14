//
//  DungeonClass.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//
//  Class for creating the procedural dungeon map
//

import Foundation
import Darwin


class Dungeon {
    

    //Constants and initializers
    let dungeonSizeWidth: Int
    let dungeonSizeHeight: Int
    let cellSizeHeight: Int
    let cellSizeWidth: Int
    let floor:Int = 0
    let wall:Int = 1
    let vwall:Int = 2
    let nothing:Int = 2

    var myDungeonDefaultRow = [Int]()
    
    struct dungeonRoomLocation {
        var x1: Int = 0
        var y1: Int = 0
        var x2: Int = 0
        var y2: Int = 0
    }

    
    
    //============================================================//
    //set init values
    //============================================================//

    //Default init values...
    init () {

        //Default sizes
        self.dungeonSizeWidth = 25
        self.dungeonSizeHeight = 15
        self.cellSizeHeight = 5
        self.cellSizeWidth = 5
        
        //create a default row for the dungeon, with "nothing" in each tile...
        self.myDungeonDefaultRow = [Int](count:dungeonSizeWidth, repeatedValue:nothing)

        
    }

    //Configurable init values...
    init (dungeonSizeWidth: Int, dungeonSizeHeight: Int, cellSizeHeight: Int, cellSizeWidth: Int) {
        self.dungeonSizeWidth = dungeonSizeWidth
        self.dungeonSizeHeight = dungeonSizeHeight
        self.cellSizeHeight = cellSizeHeight
        self.cellSizeWidth = cellSizeWidth
        
        //create a default row for the dungeon, with "nothing" in each tile...
        self.myDungeonDefaultRow = [Int](count:dungeonSizeWidth, repeatedValue:nothing)

    }

    
    //============================================================//
    //create random rooms with max cell size...
    //Algorithm: http://www.roguebasin.com/index.php?title=Grid_Based_Dungeon_Generator
    //============================================================//
    func createDungeonUsingCellMethod() -> [[Int]]{
        
        ////
        //loop through by CELL ROWs and create random rooms stored within an array of room locations.
        //I might want to consider keeping this array for later use, right now I'm throwing it away.
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
        var generatedDungeon = [[Int]](count: dungeonSizeHeight, repeatedValue:self.myDungeonDefaultRow)
        
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
                        //This is for the vertical walls, if I want different icons
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = wall
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



    //============================================================//
    //create random rooms with cellular automota...
    //Algorithm: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //============================================================//
    func createDungeonUsingCellularAutomota() -> [[String]] {
        
        return [[".","."],[".","."]]
        
    }

} //End Dungeon class

