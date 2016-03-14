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



//Ascii character set, I figure we should always support ascii. This should probably go in the dungeon though,
//since inanimate "things" are part of the dungeon class.
//TODO: Where should this live and how should it work?
struct asciiDungeonObjectArt {
    let floor:String = "."
    let wall:String = "="
    let vwall:String = "|"
    let nothing:String = " "
}




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
    //Seems like this should be a globally accessible struct...?
    //TODO: I THINK THIS IS A GREAT PLACE TO MAKE A PROTOCOL!
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

    //The key components of our dungeon...
    var dungeonMap = [[Int]]()
    var dungeonRooms: [DungeonRoom]
    var heros: [Hero]
    var monsters: [Monster]
    var items: [Item]
    
    /*
    I think these should be in the Dungeon class, since they're in the dungeon.
    I'm thinking something needs to keep track of where all the objects are.
    Example of why this would be helpful...
    
    func getObjectsInLineOfSight (myLocation: dungeonLocation) -> [objects] {
    
    }

    That said, I'm not totally sure about this.
    */
    
    
    
    
    
    
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
        self.dungeonSizeWidth = 100
        self.dungeonSizeHeight = 70
        self.cellSizeWidth = 30
        self.cellSizeHeight = 20
        self.numberOfRooms = 20
        
        self.dungeonMap = [[Int]](count: dungeonSizeHeight, repeatedValue:[Int](count:dungeonSizeWidth, repeatedValue:nothing))
        
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]
        
        self.heros = [Hero()]
        self.monsters = [Monster()]
        self.items = [Item()]
        
        
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

        self.heros = [Hero()]
        self.monsters = [Monster()]
        self.items = [Item()]
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


    //Will replace the func above, separating the creation of rooms from the drawing of the map.
    func generateDungeonRoomsUsingCellMethod() {
    
    }
    
    
    //=====================================================================================================//
    //
    //create random cells using a best fit approach, lower-left (0,0) to upper-right (max width, max height)
    //
    //=====================================================================================================//
    func generateDungeonRoomsUsingFitLeftToRight() {
        
        var randomWidth: Int
        var randomWidthOffset: Int
        var randomHeight: Int
        var randomHeightOffset: Int
        
        var createdRooms = 0

        
        //used for finding minimum room placement point:
        var minX: Int
        var minY: Int
      
        var canWeBuildHere: Bool = false
        
        //Create each room and place it...
        while createdRooms < self.numberOfRooms {
        
            minX = 0
            minY = 0
            
            //create random room size for the room
            randomWidthOffset = Int(arc4random_uniform(UInt32(cellSizeWidth/3)))
            randomWidth = max((cellSizeWidth/5), (Int(arc4random_uniform(UInt32(cellSizeWidth)))))
            
            randomHeightOffset = Int(arc4random_uniform(UInt32(cellSizeHeight/3)))
            randomHeight = max((cellSizeHeight/5), Int(arc4random_uniform(UInt32(cellSizeHeight))))
            
            
            //Loop through each (x,y) point to see where we can build...
            var columnCheck = 0
            var rowCheck = 0
            canWeBuildHere = false
            
            while (columnCheck < dungeonSizeWidth) && (canWeBuildHere == false) {
                while (rowCheck < dungeonSizeHeight) && (canWeBuildHere == false) {
                    
                    if doRoomsCollide(columnCheck, y1: rowCheck, x2: (columnCheck + randomWidthOffset + randomWidth), y2: (rowCheck + randomHeight + randomHeightOffset)) {
                        
                        canWeBuildHere = false
                        
                    } else {
                    
                        minX = columnCheck
                        minY = rowCheck
                        canWeBuildHere = true
                        
                    }
                    
                    rowCheck++
                    
                }
                
                rowCheck = 0
                columnCheck++
                
            }
            
            
            if canWeBuildHere == true {
                
                //create the new room...
                dungeonRooms.append(DungeonRoom.init(roomId: createdRooms, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil))
                
                dungeonRooms[createdRooms].location.x1 = minX
                dungeonRooms[createdRooms].location.x2 = minX + randomWidthOffset + randomWidth
                dungeonRooms[createdRooms].location.y1 = minY
                dungeonRooms[createdRooms].location.y2 = minY + randomHeightOffset + randomHeight
                
                createdRooms++

            }

        }
        
        drawDungeonRooms()
        
    }
    
    
    
    //=====================================================================================================//
    //Func to check if rooms, if all dungeonRooms are populated
    //=====================================================================================================//

    func doRoomsCollide(x1: Int, y1: Int, x2: Int, y2: Int) -> Bool {
        
        var wellDoThey: Bool = false
        
        for var roomIterator in 0...dungeonRooms.count - 1 {
            
            //This  tests if the lower left, or upper right, or lower right, or upper left corners overlap with the given room in the iterator.
            //If any overlap, the rooms have collided.
            if (((x1 >= dungeonRooms[roomIterator].location.x1) && (x1 <= dungeonRooms[roomIterator].location.x2)) && ((y1 >= dungeonRooms[roomIterator].location.y1) && (y1 <= dungeonRooms[roomIterator].location.y2))) || (((x2 >= dungeonRooms[roomIterator].location.x1) && (x2 <= dungeonRooms[roomIterator].location.x2)) && ((y2 >= dungeonRooms[roomIterator].location.y1) && (y2 <= dungeonRooms[roomIterator].location.y2))) || (((x2 >= dungeonRooms[roomIterator].location.x1) && (x2 <= dungeonRooms[roomIterator].location.x2)) && ((y1 >= dungeonRooms[roomIterator].location.y1) && (y1 <= dungeonRooms[roomIterator].location.y2))) || (((x1 >= dungeonRooms[roomIterator].location.x1) && (x1 <= dungeonRooms[roomIterator].location.x2)) && ((y2 >= dungeonRooms[roomIterator].location.y1) && (y2 <= dungeonRooms[roomIterator].location.y2))){
                
                wellDoThey = true
                
            }
            
        }
        
        return wellDoThey
        
    }
    
    
    
    //=====================================================================================================//
    //Func to draw rooms, if all dungeonRooms are populated
    //=====================================================================================================//
    func drawDungeonRooms() -> Void {
        
        
        //Iterate through each room...
        for drawRoomIterator in 0...(dungeonRooms.count - 1) {
            
            var row = 0
            var column = 0
            
            for row = dungeonRooms[drawRoomIterator].location.y1; ((row <= dungeonRooms[drawRoomIterator].location.y2) && (row < dungeonSizeHeight)); row++ {
                
                for column = dungeonRooms[drawRoomIterator].location.x1; ((column <= dungeonRooms[drawRoomIterator].location.x2) && (column < dungeonSizeWidth)); column++ {
                    
                    if ((row == dungeonRooms[drawRoomIterator].location.y1) || (row == dungeonRooms[drawRoomIterator].location.y2) || (column == dungeonRooms[drawRoomIterator].location.x1) || (column == dungeonRooms[drawRoomIterator].location.x2)) {
                        dungeonMap[row][column] = wall
                    } else {
                        dungeonMap[row][column] = floor
                    }
                    
                }
                
            }
            
        }
        
    }

    
    
    //=====================================================================================================//
    //create a room using cellular automota... 
    //Note: this could be a one-room level, or a single room within a room of cells
    //Algorithm: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //=====================================================================================================//
    func generateDungeonRoomUsingCellularAutomota() -> Void {
        
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
            
            for var row2 = 0; row2 < dungeonMap.count; row2++ {
                for var column2 = 0; column2 < dungeonMap[row2].count; column2++ {
                    
                    if howManyWallsAreAroundMe(column2,y:row2) > 5 {
                        dungeonMap[row2][column2] = 1
                    } else if howManyWallsAreAroundMe(column2,y:row2) < 3 {
                        dungeonMap[row2][column2] = 0
                    }
                    
                }
            }
        }
        
    }
    
    

    
    //I'm sure there's probably a much more elegant way to do this. Hrm.
    func howManyWallsAreAroundMe(x:Int, y:Int) -> Int {
    
        var walls = 0
        
        
        if (x == 0) || (x > dungeonSizeWidth-2) || (y == 0) || (y > dungeonSizeHeight-2) {
        
            //do nothing
        
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
    //Set the dungeon back to basics
    //
    //=====================================================================================================//
    func resetDungeonMap() -> Void {
        
        self.dungeonMap = [[Int]](count: dungeonSizeHeight, repeatedValue:[Int](count:dungeonSizeWidth, repeatedValue:nothing))
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]
    }
    
    
    
    
    //=====================================================================================================//
    //Func to connect an array of DungeonRoom struct
    //
    //=====================================================================================================//
    func connectDungeonRooms() -> Void {
        //Func to connect rooms
        //And draw connections
        
        
        
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

