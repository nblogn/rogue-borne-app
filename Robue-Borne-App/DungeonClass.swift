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
    

    //Constants and initializers...
    let dungeonSizeWidth: Int
    let dungeonSizeHeight: Int
    let cellSizeHeight: Int
    let cellSizeWidth: Int
    let numberOfRooms: Int
    
    //consider enum...
    let floor:Int = 0
    let wall:Int = 1
    let vwall:Int = 2
    let nothing:Int = 2

    
    //Simple location struct...
    struct DungeonRoomLocation {
        var x1: Int = 0
        var y1: Int = 0
        var x2: Int = 0
        var y2: Int = 0
    }
    
    //A DungeonRoom...
    struct DungeonRoom {
        var roomId: Int
        var location: DungeonRoomLocation
        var connectedRooms: [DungeonRoom]?
    }

    //The two key components of our dungeon...
    var dungeonRooms: [DungeonRoom]
    var dungeonMap = [[Int]]()
    
    
    
    //=====================================================================================================//
    //set init values
    //
    //   !!!TODO!!!
    //      Eventually I need to add the method for creating the map
    //      to the init config. Then I can just create the map when I
    //      create an instance of the class. As of now, I have to call
    //      the func explicitly to create the map. Not a big deal, but
    //      not ideal from a design perspective. I think.
    //
    //=====================================================================================================//

    //Default init values...
    init () {

        //Default sizes
        self.dungeonSizeWidth = 80
        self.dungeonSizeHeight = 50
        self.cellSizeWidth = 14
        self.cellSizeHeight = 10
        self.numberOfRooms = 10
        
        self.dungeonMap = [[Int]](count: dungeonSizeHeight, repeatedValue:[Int](count:dungeonSizeWidth, repeatedValue:nothing))
        
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]
        
    }

    //Configurable init values...
    init (dungeonSizeWidth: Int, dungeonSizeHeight: Int, cellSizeHeight: Int, cellSizeWidth: Int, numberOfRooms: Int) {
        self.dungeonSizeWidth = dungeonSizeWidth
        self.dungeonSizeHeight = dungeonSizeHeight
        self.cellSizeHeight = cellSizeHeight
        self.cellSizeWidth = cellSizeWidth
        self.numberOfRooms = numberOfRooms
        
        self.dungeonMap = [[Int]](count: dungeonSizeHeight, repeatedValue:[Int](count:dungeonSizeWidth, repeatedValue:nothing))
        
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]

    }

    
    //=====================================================================================================//
    //
    //create random rooms with max cell size...
    //Algorithm: http://www.roguebasin.com/index.php?title=Grid_Based_Dungeon_Generator
    //
    //=====================================================================================================//
    func createDungeonUsingCellMethod() -> Void{
        
        ////
        //loop through by CELL ROWs and create random rooms stored within an array of room locations.
        //I might want to consider keeping this array for later use, right now I'm throwing it away.
        ////
        
        //Calculate number of cells based on dungeon size
        let numberOfCellsHeight = dungeonSizeHeight / cellSizeHeight
        let numberOfCellsWidth = dungeonSizeWidth / cellSizeWidth
        var numberOfCells =  numberOfCellsHeight * numberOfCellsWidth
        
        //Create some max offsets
        let maxOffsetX: UInt32 = (UInt32(cellSizeWidth) / 2) - 1
        let maxOffsetY: UInt32 = (UInt32(cellSizeHeight) / 2) - 1
        
        //Init the dungeon cells
        var dungeonCellRooms = [DungeonRoomLocation]()
        var tempDungeonRoom = DungeonRoomLocation()
        
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
                    
                    dungeonCellRooms.append(tempDungeonRoom)
                    
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
        var generatedDungeon = [[Int]](count: dungeonSizeHeight, repeatedValue:[Int](count:dungeonSizeWidth, repeatedValue:nothing))
        
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
        numberOfCells = dungeonCellRooms.count
        var numberOfCellsIterator = 0
        
        //Actually draw the rooms in the dungeons array
        while numberOfCellsIterator < numberOfCells{
            
            
            roomX1 = dungeonCellRooms[numberOfCellsIterator].x1
            roomY1 = dungeonCellRooms[numberOfCellsIterator].y1
            roomX2 = dungeonCellRooms[numberOfCellsIterator].x2
            roomY2 = dungeonCellRooms[numberOfCellsIterator].y2
            
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
        dungeonMap = generatedDungeon
        
    }


    
    //=====================================================================================================//
    //create random rooms using a big bang approach...
    //
    //=====================================================================================================//
    func generateDungeonRoomsUsingBigBang() {
        
        let numberOfRooms = 10
        
        var randomWidth: Int
        var randomWidthOffset: Int
        var randomHeight: Int
        var randomHeightOffset: Int
        
        
        //used for finding minimum room placement point:
        var minY: Int
        var minX: Int
        var priorRoomIterator: Int
        
        
        for roomIterator in 1...numberOfRooms {
            
            randomWidthOffset = Int(arc4random_uniform(UInt32(cellSizeWidth/2)))
            randomWidth = Int(arc4random_uniform(UInt32(cellSizeWidth/2)))
            
            randomHeightOffset = Int(arc4random_uniform(UInt32(cellSizeHeight/2)))
            randomHeight = Int(arc4random_uniform(UInt32(cellSizeHeight/2)))
            
            
            //TODO -> a check to determin (x,y) start
            // feels like this should be recursive...
            // call this again with x1,y1 as starting points until reach max width/height?
            
            if (roomIterator > 1) {
                
                minY = 0
                minX = 0
                priorRoomIterator = 0

                /*
                //for a given y-axis range (cellHeight) find the lowest x-axis column available.
                for priorRoomIterator in 1...roomIterator {
                    
                    if
                    minX = dungeonRooms[priorRoomIterator].location.x2
                    minY = dungeonRooms[priorRoomIterator].location.y2
                }
                
*/
                
                
                
            }
            else {
            
                //find random height (with max == cellSizeHeight), do the same for width, then place the bitch.
                //Int(arc4random_uniform(Uint(cellSizeHeight))
                dungeonRooms[roomIterator].location.x1 = randomWidthOffset
                dungeonRooms[roomIterator].location.x2 = randomWidthOffset + randomWidth
                dungeonRooms[roomIterator].location.y1 = randomHeightOffset
                dungeonRooms[roomIterator].location.y2 = randomHeightOffset + randomHeight
            }

        }
        
    
    }


    //=====================================================================================================//
    //create a room using cellular automota... (note, this could be a one-room level)
    //Algorithm: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //=====================================================================================================//
    func drawDungeonRoomUsingCellularAutomota() -> Void {
        
        var randWalls:Int
        
        for var row = 0; row < dungeonMap.count; row++ {
            for var column = 0; column < dungeonMap[row].count; column++ {
                
                randWalls = Int(arc4random_uniform(UInt32(100)))
                
                if randWalls > 55 {
                    dungeonMap[row][column] = 1
                }
            }
        }
        
        for _ in 1...5 {
            
            for var row = 0; row < dungeonMap.count; row++ {
                
                for var column = 0; column < dungeonMap[row].count; column++ {
                    
                    if howManyWallsAreAroundMe(column,y:row) > 5 {
                        dungeonMap[row][column] = 1
                    }
                    
                }
            }
        }
        
    }
    
    

    
    //I'm sure there's probably a much more elegant way to do this. Hrm.
    func howManyWallsAreAroundMe(x:Int, y:Int) -> Int {
    
        var walls = 0
        
        
        if (x == 0) || (x > 78) || (y == 0) || (y > 48) {
        
        
        } else {

            if dungeonMap[y][x-1] == 1 {
                walls++
            }

            if dungeonMap[y-1][x+1] == 1 {
                walls++
            }
            
            if dungeonMap[y-1][x-1] == 1 {
                walls++
            }
        
            if dungeonMap[y+1][x] == 1 {
                walls++
            }
            
            if dungeonMap[y+1][x+1] == 1 {
                walls++
            }
            
            if dungeonMap[y+1][x-1] == 1 {
                walls++
            }
            
            if dungeonMap[y][x+1] == 1 {
                walls++
            }
            
            if dungeonMap[y][x-1] == 1 {
                walls++
            }
        }
        
        return walls
        
    }
    
    
    
    //=====================================================================================================//
    //Func to draw rooms
    //Algorithm: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //=====================================================================================================//

    func drawDungeonRooms() -> Void {
        
    }
    
    //=====================================================================================================//
    //Func to connect an array of DungeonRoom struct
    //
    //=====================================================================================================//

    func connectDungeonRooms() -> Void {
        //Func to connect rooms
        //And draw connections?
    }
    
    
    
    //=====================================================================================================//
    // Print a 2D array
    // Mostly for debugging at this point. Or whatever.
    //=====================================================================================================//
    func printDungeon(mazeToPrint: [[String]]){
        
        for var row = 0; row < mazeToPrint.count; row++ {
            for var column = 0; column < mazeToPrint[row].count; column++ {
                print("\(mazeToPrint[row][column])", terminator:"")
            }
            print(" - \(row)")
        }
        
    }
    


} //End Dungeon class

