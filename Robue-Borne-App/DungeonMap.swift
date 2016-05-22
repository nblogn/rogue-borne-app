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
import SpriteKit


class DungeonMap: SKNode {

    //Constants and initializers...
    let dungeonSizeWidth: Int
    let dungeonSizeHeight: Int
    let cellSizeHeight: Int
    let cellSizeWidth: Int
    let numberOfRooms: Int
    
    
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
    var dungeonMap = [[TileClass]]()
    var dungeonRooms: [DungeonRoom]
    
    
    
    /*
    I think these should be in the Dungeon class, since they're in the dungeon.
    I'm thinking something needs to keep track of where all the objects are.
    Example of why this would be helpful...

    func getObjectsInLineOfSight (myLocation: dungeonLocation) -> [objects] {

    }

    That said, I'm not totally sure about this.

    var heros: [Hero]
    var monsters: [Monster]
    var items: [Item]

    On second thought, I think maybe there should be a "level" class which includes all of this? 
    Or maybe each instance of the dungeon class is a level? Ugh. No idea.
     
    */
    
    
    func getTileByLocation (X: Int, Y: Int) -> TileClass {
        return self.dungeonMap[X][Y]
    }
    
    
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Default init values...
    override init () {

        //Default sizes
        self.dungeonSizeWidth = 100
        self.dungeonSizeHeight = 70
        self.cellSizeWidth = 50
        self.cellSizeHeight = 40
        self.numberOfRooms = 20
        
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]
        
        /*self.heros = [Hero()]
        self.monsters = [Monster()]
        self.items = [Item()]*/
        
        super.init()
        
        createBlankDungeonMap()
        

        
    }

    //Configurable init values...
    //TODO: Add dungeonType to the init (versus the other way I'm doing it now in PlayScene
    init (dungeonSizeWidth: Int, dungeonSizeHeight: Int, cellSizeHeight: Int, cellSizeWidth: Int, numberOfRooms: Int) {
        self.dungeonSizeWidth = dungeonSizeWidth
        self.dungeonSizeHeight = dungeonSizeHeight
        self.cellSizeHeight = cellSizeHeight
        self.cellSizeWidth = cellSizeWidth
        self.numberOfRooms = numberOfRooms
        
        self.dungeonRooms = [DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil)]

        /*self.heros = [Hero()]
        self.monsters = [Monster()]
        self.items = [Item()]*/
        
        super.init()
        
        createBlankDungeonMap()

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
                numberOfWidthCellsIterator += 1
            }
            
            columnIterator = 0
            numberOfWidthCellsIterator = 0
            rowIterator += cellSizeHeight
            numberOfHeightCellsIterator += 1
        }
        
        
        ////
        //Now that I have the array of room locations, I will draw the rooms into the dungeon array.
        ////
        
        //Temp dungeon to be returned
        var generatedDungeon = [[TileClass]](count: dungeonSizeHeight, repeatedValue:[TileClass](count:dungeonSizeWidth, repeatedValue: TileClass(tileToCreate: Tile.Nothing)))
        
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
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = TileClass(tileToCreate: Tile.Wall)
                    }
                    else if (columnIterator == 0) || (columnIterator == roomWidth-1) {
                        //This is for the vertical walls, if I want different icons
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = TileClass(tileToCreate: Tile.Wall)
                    }
                    else {
                        generatedDungeon[roomY1+rowIterator][roomX1+columnIterator] = TileClass(tileToCreate: Tile.Ground)
                    }
                    columnIterator += 1
                    
                }
                
                columnIterator = 0
                rowIterator += 1
                
            }
            
            rowIterator = 0
            columnIterator = 0
            
            numberOfCellsIterator += 1
            
        }
        
        //Finally, return the full generated dungeon
        dungeonMap = generatedDungeon
        
        drawDungeonSpriteNodes()
        
    }


    //Will replace the func above, separating the creation of rooms from the drawing of the map.
    func generateDungeonRoomsUsingCellMethod() {


    }
    
    
    
    
    //=====================================================================================================//
    //create a room using cellular autamota...
    //Note: this could be a one-room level, or a single room within a room of cells
    //Algorithm: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //=====================================================================================================//
    func generateDungeonRoomUsingCellularAutomota() -> Void {
        
        var randWalls:Int
        
        //Let's make a room, for now it's taking up the whole dungeon
        //TODO: Make extensible so this can be a single room within a larger dungeon
        dungeonRooms.append(DungeonRoom.init(roomId: 0, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: dungeonSizeWidth, y2: dungeonSizeHeight), connectedRooms: nil))
        
        for row in 0 ..< dungeonMap.count {
            for column in 0 ..< dungeonMap[row].count {
                
                randWalls = Int(arc4random_uniform(UInt32(100)))
                
                if randWalls > 55 {
                    dungeonMap[row][column] = TileClass(tileToCreate: Tile.Wall)
                }
            }
        }
        
        
        for _ in 1...5 {
            
            for row2 in 0 ..< dungeonMap.count {
                for column2 in 0 ..< dungeonMap[row2].count {
                    
                    if howManyWallsAreAroundMe(x:column2,y:row2) > 5 {
                        dungeonMap[row2][column2] = TileClass(tileToCreate: Tile.Wall)
                    } else if howManyWallsAreAroundMe(x:column2,y:row2) < 3 {
                        dungeonMap[row2][column2] = TileClass(tileToCreate: Tile.Ground)
                    }
                    
                }
            }
        }
        
        drawDungeonSpriteNodes()
        
    }

    
    //=====================================================================================================//
    //
    //create random cells using a best fit approach, lower-left (0,0) to upper-right (max width, max height)
    //
    //Configuable defaults:
    //  density == smaller value leads to more spaing between rooms
    //  roomSize == larger value leads to smaller rooms
    //
    //=====================================================================================================//
    func generateDungeonRoomsUsingFitLeftToRight(roomSize: Int = 3, density: Int = 3) {
        
        var randomWidth: Int
        var randomWidthOffset: Int
        var randomWidthOffset2: Int
        var randomHeight: Int
        var randomHeightOffset: Int
        var randomHeightOffset2: Int
        
        var createdRooms = 0
        var roomDoesNotFit = 0
        
        //Configurable via default roomSize (bigger == smaller)
        let maxRoomWidth = Int(dungeonSizeWidth / roomSize)
        let maxRoomHeight = Int(dungeonSizeHeight / roomSize)
        
        //used for finding minimum room placement point:
        var minX: Int
        var minY: Int
      
        var canWeBuildHere: Bool = false
        
        //Create each room and place it...
        //Do this until I've tried to fit 10 maps that won't fit.
        while roomDoesNotFit < 2 {
        
            minX = 0
            minY = 0
            
            //create random room size for the room
            randomWidthOffset = 3 //Int(arc4random_uniform(UInt32(maxRoomWidth/density)))
            randomWidthOffset2 = 3 //Int(arc4random_uniform(UInt32(maxRoomWidth/density)))
            randomWidth = max(10, Int(arc4random_uniform(UInt32(maxRoomWidth))))
                //max((maxRoomWidth/4), (Int(arc4random_uniform(UInt32(maxRoomWidth)))))
            
            randomHeightOffset = 2 //Int(arc4random_uniform(UInt32(maxRoomHeight/density)))
            randomHeightOffset2 = 2 //Int(arc4random_uniform(UInt32(maxRoomHeight/density)))
            randomHeight = max(6, Int(arc4random_uniform(UInt32(maxRoomHeight))))
                //max((maxRoomHeight), Int(arc4random_uniform(UInt32(maxRoomHeight))))
            
            
            //Loop through each (x,y) point to see where we can build...
            var columnCheck = 0
            var rowCheck = 0
            canWeBuildHere = false
            
            while (columnCheck < dungeonSizeWidth) && (canWeBuildHere == false) {
                while (rowCheck < dungeonSizeHeight) && (canWeBuildHere == false) {
                    
                    if doRoomsCollide(x1: columnCheck, y1: rowCheck, x2: (columnCheck + randomWidthOffset + randomWidth + randomWidthOffset2), y2: (rowCheck + randomHeight + randomHeightOffset + randomWidthOffset2)) {
                        
                        //If the room overlaps another room, we can't build it.
                        canWeBuildHere = false
                        
                    } else if ((columnCheck + randomWidthOffset + randomWidth) > dungeonSizeWidth) || ((rowCheck + randomHeight + randomHeightOffset) > dungeonSizeHeight) {
                        
                        //If the room falls outside the border of the dungeon, we can't build it.
                        canWeBuildHere = false
                        
                    } else {
                        
                        //Yes We CAN build here!
                        minX = columnCheck
                        minY = rowCheck
                        canWeBuildHere = true
                        
                    }
                    
                    rowCheck += 1
                    
                }
                
                rowCheck = 0
                columnCheck += 1
                
            }
            
            if canWeBuildHere == true {
                
                //create the new room...
                if createdRooms > 0 {
                    dungeonRooms.append(DungeonRoom.init(roomId: createdRooms, location: DungeonRoomLocation.init(x1: 0, y1: 0, x2: 0, y2: 0), connectedRooms: nil))
                }
                
                dungeonRooms[createdRooms].location.x1 = minX + randomWidthOffset
                dungeonRooms[createdRooms].location.x2 = minX + randomWidth - randomWidthOffset2
                dungeonRooms[createdRooms].location.y1 = minY + randomHeightOffset
                dungeonRooms[createdRooms].location.y2 = minY + randomHeight - randomHeightOffset2
                
                createdRooms += 1

            } else {
                
                roomDoesNotFit += 1

            }

        }
        
        drawDungeonRooms()
        connectDungeonRooms()
        drawDungeonSpriteNodes()
        
    }
    
    
    
    //=====================================================================================================//
    //Func to check if dungeonRooms collide
    //=====================================================================================================//
    private func doRoomsCollide(x1 x1: Int, y1: Int, x2: Int, y2: Int) -> Bool {
        
        var wellDoThey: Bool = false
        
        for roomIterator in 0...dungeonRooms.count - 1 {
            
            //Note; first I tried to check all the things that would test if they overlapped. This was fucking tough.
            //Then I googled and discovered it's much easier to test if they DON'T overlap. This was much easier.
            
            if ((x1 > dungeonRooms[roomIterator].location.x2) || (x2 < dungeonRooms[roomIterator].location.x1) || (y1 > dungeonRooms[roomIterator].location.y2) || (y2 < dungeonRooms[roomIterator].location.y1)) && (!wellDoThey) {

                wellDoThey = false
                
            } else {
                
                wellDoThey = true
        
            }
        
        }

        return wellDoThey
        
    }
    
    
    
    //=====================================================================================================//
    //
    //Func to define the rooms within the dungeon, when all dungeonRooms are populated
    //
    //=====================================================================================================//
    private func drawDungeonRooms() -> Void {
        
        
        //Iterate through each room...
        for drawRoomIterator in 0...(dungeonRooms.count - 1) {
            
            var row = 0
            var column = 0
            
            for row = dungeonRooms[drawRoomIterator].location.y1; ((row <= dungeonRooms[drawRoomIterator].location.y2) && (row < dungeonSizeHeight)); row += 1 {
                
                for column = dungeonRooms[drawRoomIterator].location.x1; ((column <= dungeonRooms[drawRoomIterator].location.x2) && (column < dungeonSizeWidth)); column += 1 {
                    
                    //Check to see if we are drawing walls or floor...
                    if ((row == dungeonRooms[drawRoomIterator].location.y1) || (row == dungeonRooms[drawRoomIterator].location.y2) || (column == dungeonRooms[drawRoomIterator].location.x1) || (column == dungeonRooms[drawRoomIterator].location.x2)) {
                        dungeonMap[row][column] = TileClass(tileToCreate: Tile.Wall)
                    } else {
                        dungeonMap[row][column] = TileClass(tileToCreate: Tile.Ground)
                    }
                    
                }
                
            }
            
        }
        
    }

    

    //=====================================================================================================//
    //
    //I'm sure there's probably a much more elegant way to do this. Hrm.
    //
    //=====================================================================================================//
    private func howManyWallsAreAroundMe(x x:Int, y:Int, tileType: Tile = Tile.Wall) -> Int {
    
        var walls = 0
        
        if (x == 0) || (x > dungeonSizeWidth-2) || (y == 0) || (y > dungeonSizeHeight-2) {
        
            //do nothing
        
        } else {

            if dungeonMap[y][x-1].tileType == tileType {
                walls += 1
            }

            if dungeonMap[y-1][x+1].tileType == tileType {
                walls += 1
            }
            
            if dungeonMap[y-1][x-1].tileType == tileType {
                walls += 1
            }
        
            if dungeonMap[y+1][x].tileType == tileType {
                walls += 1
            }
            
            if dungeonMap[y+1][x+1].tileType == tileType {
                walls += 1
            }
            
            if dungeonMap[y+1][x-1].tileType == tileType {
                walls += 1
            }
            
            if dungeonMap[y][x+1].tileType == tileType {
                walls += 1
            }
            
            if dungeonMap[y][x-1].tileType == tileType {
                walls += 1
            }
        }
        
        return walls
        
    }
    
    
    
    //=====================================================================================================//
    //Functions to connect an array of DungeonRoom struct
    //Given an array of rooms, this will draw corridors between them, and add them as connections
    //=====================================================================================================//
    private func connectDungeonRooms() -> Void {
        
        var closestRoom: Int?
        var xDigger: Int
        var yDigger: Int
        var x: Int
        var y: Int
        var destinationX: Int
        var destinationY: Int

        var roomIterator: Int = 0
        var connectedRooms: Int = 0
        var doorCreatedInVerticalWall: Bool = false
        var doorCreatedInHorizontalWall: Bool = false
        
        while (connectedRooms <= dungeonRooms.count) {
            
            closestRoom = findClosestRoomToRoomId(roomIterator)
            if closestRoom == nil {
                break
            }
        
            if (closestRoom != nil) {
                //Find the starting point, in this case the middle of the room
                x = Int((dungeonRooms[roomIterator].location.x1 + dungeonRooms[roomIterator].location.x2)/2)
                y = Int((dungeonRooms[roomIterator].location.y1 + dungeonRooms[roomIterator].location.y2)/2)
                
                //Find the destination point, the middle of the target room
                destinationX = Int((dungeonRooms[closestRoom!].location.x1 + dungeonRooms[closestRoom!].location.x2)/2)
                destinationY = Int((dungeonRooms[closestRoom!].location.y1 + dungeonRooms[closestRoom!].location.y2)/2)

                //link the rooms
                if dungeonRooms[roomIterator].connectedRooms == nil {
                    dungeonRooms[roomIterator].connectedRooms = []
                }
                dungeonRooms[roomIterator].connectedRooms?.append(dungeonRooms[closestRoom!])

                if dungeonRooms[closestRoom!].connectedRooms == nil {
                    dungeonRooms[closestRoom!].connectedRooms = []
                }
                dungeonRooms[closestRoom!].connectedRooms?.append(dungeonRooms[roomIterator])
                connectedRooms += 1
                
                
                //Dig the connection between the rooms
                xDigger = x
                yDigger = y                
                while (xDigger != destinationX) || (yDigger != destinationY) {
                    
                    //Change the current tile...
                    switch dungeonMap[yDigger][xDigger].tileType {
                        case Tile.Wall:
                            do {
                                
                                dungeonMap[yDigger][xDigger] = TileClass (tileToCreate: Tile.Door)

                                //TODO: Add checks for multiple doors in a row
                                if (dungeonMap[yDigger-1][xDigger].tileType == Tile.Wall) || (dungeonMap[yDigger+1][xDigger].tileType == Tile.Wall) {
                                    
                                    doorCreatedInVerticalWall = true
                                    
                                } else if (dungeonMap[yDigger][xDigger+1].tileType == Tile.Door) || (dungeonMap[yDigger][xDigger-1].tileType == Tile.Door) {
                                    
                                    doorCreatedInHorizontalWall = true
                                    
                                }
                                
                            }
                        case Tile.Ground:
                            do {
                                //nothing, move along
                            }
                        case Tile.Nothing:
                            do {
                                dungeonMap[yDigger][xDigger] = TileClass (tileToCreate: Tile.CorridorHorizontal)
                            }
                        default: break
                    }
                    
                    
                    //Decide how to move onto the next tile as we traverse to our destination
                    let randNum = Int(arc4random_uniform(10))
                    
                    //If we just created a wall, ensure we move out of the wall (so we don't build several doors beside each other:
                    if doorCreatedInHorizontalWall {
                        
                        if (yDigger < destinationY){
                            yDigger += 1
                            doorCreatedInHorizontalWall = false
                        } else {
                            yDigger -= 1
                            doorCreatedInHorizontalWall = false
                        }
                    } else if doorCreatedInVerticalWall {
                        if (xDigger < destinationX){
                            xDigger += 1
                            doorCreatedInVerticalWall = false
                        } else {
                            xDigger -= 1
                            doorCreatedInVerticalWall = false
                        }
                        
                    } else { //no door was created, so we can move randomly in the right general direction

                        if (randNum < 6)
                        {
                            if xDigger > destinationX {
                                xDigger -= 1
                            } else  if xDigger < destinationX {
                                xDigger += 1
                            }
                            
                        } else {
                            if yDigger > destinationY {
                                yDigger -= 1
                            } else if yDigger < destinationY {
                                yDigger += 1
                            }
                        }
                    }
                }
                
                if closestRoom! >= dungeonRooms.count-1 {
                    roomIterator = 0
                } else {
                    roomIterator = closestRoom!
                }
                
                print("connectDungeon roomIterator == ", roomIterator)
                
                
            } else {
                
                if (roomIterator >= dungeonRooms.count-1) {
                    
                    roomIterator = 0
                    
                } else {
                    
                    roomIterator += 1
                    
                }
                
            }
            
        }
        
    }
    
    //Finds closest room to given roomId, can filter by how many connections that room has...
    private func findClosestRoomToRoomId(room:Int, targetRoomConnections:Int = 0) -> Int? {
        
        let roomMidpointX = Int((dungeonRooms[room].location.x1 + dungeonRooms[room].location.x2)/2)
        let roomMidpointY = Int((dungeonRooms[room].location.y1 + dungeonRooms[room].location.y2)/2)

        var targetRoomMidpointX: Int
        var targetRoomMidpointY: Int
        var minDistance: Float?
        var compDistance: Float?
        var aSquared: Float
        var bSquared: Float
        
        var closestRoom: Int?
        
        for roomIterator in 0...dungeonRooms.count-1 {
            
            if (roomIterator != room) && (dungeonRooms[roomIterator].connectedRooms == nil) {
                
                targetRoomMidpointX = Int((dungeonRooms[roomIterator].location.x1 + dungeonRooms[roomIterator].location.x2)/2)
                targetRoomMidpointY = Int((dungeonRooms[roomIterator].location.y1 + dungeonRooms[roomIterator].location.y2)/2)
                
                aSquared = Float((roomMidpointX - targetRoomMidpointX)*(roomMidpointX - targetRoomMidpointX))
                bSquared = Float((roomMidpointY - targetRoomMidpointY)*(roomMidpointY - targetRoomMidpointY))
                    
                compDistance = sqrt(aSquared + bSquared)
                
                if minDistance == nil {
                    
                    minDistance = compDistance
                    closestRoom = roomIterator
                    
                } else if compDistance < minDistance {
                    
                    minDistance = compDistance!
                    closestRoom = roomIterator
                    
                }
                
            }
        }
        
        return closestRoom

    }
    
    
    
    //=====================================================================================================//
    //
    //Draw the dungeon sprite nodes!
    //            
    //Let's use circuit boards for the rooms!! TRON ftw!
    //https://www.google.com/search?q=circuit+board&client=safari&rls=en&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiuxq365vbLAhUW-mMKHdFIDtYQ_AUIBygB&biw=1440&bih=839
    //
    //
    // A note about anchor points: Sprites are drawn by default centered on their position (anchor .5/.5)
    // However, if you change this, the shadows don't seem to work correctly. Therefor, for walls and characters
    // I'm using the default. But for placing the rooms, I'm using 0/0 because there are no shadows, and I
    // already have this coordinate, so it's easier. Reference:
    // https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Sprites/Sprites.html
    //
    //=====================================================================================================//

    //Draws the dungeon using the array of dungeon tiles within the myDungeon object
    private func drawDungeonSpriteNodes(){
        
        ////
        //Draw the rooms first
        for roomIterator in 0...dungeonRooms.count-1 {
            
            let coordinate1 = convertBoardCoordinatetoCGPoint(dungeonRooms[roomIterator].location.x1, y: dungeonRooms[roomIterator].location.y1)
            let coordinate2 = convertBoardCoordinatetoCGPoint(dungeonRooms[roomIterator].location.x2, y: dungeonRooms[roomIterator].location.y2)
            let width = coordinate2.x - coordinate1.x
            let height = coordinate2.y - coordinate1.y
            
            
            let room = SKSpriteNode()
            room.position = coordinate1
            room.anchorPoint = CGPoint(x:0, y:0)
            room.lightingBitMask = LightCategory.Hero
            room.size = CGSize(width: width, height: height)
            room.zPosition = 1
            room.shadowedBitMask = LightCategory.Hero
            
            let imageNumber = String(1+arc4random_uniform(UInt32(9)))
            let imageName = "cb" + imageNumber + "_n"
            
            room.texture = SKTexture(imageNamed: imageName)
            room.normalTexture = SKTexture(imageNamed: imageName)
            
            //Add the room to the dungeon:
            addChild(room)
            
        }
        
        
        ////
        //Draw hallways using paths:
        /*
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, 100.0, 100.0);
        CGPathAddLineToPoint(pathToDraw, NULL, 50.0, 50.0);
        yourline.path = pathToDraw;
        [yourline setStrokeColor:[SKColor redColor]];
        [self addChild:yourline];
        */
        
        
        //////////
        //Draw hallways -- Loop through all tiles, draw other shit (hallways, doors, etc.)
        
        // TODO: Currently drawing walls as tiles, should move this to be drawn with the rooms for lighting
        // Note this spritekit bug: http://stackoverflow.com/questions/28662600/sklightnode-cast-shadow-issue
        
        for row in 0..<dungeonMap.count {
            
            for column in 0..<dungeonMap[row].count {
                
                //Stack each tileSprite in a grid, left to right, then top to bottom. Note: in the SpriteKit coordinate system,
                //y values increase as you move up the screen and decrease as you move down.
                let point = CGPoint(x: (column*tileSize.width), y: (row*tileSize.height))
                dungeonMap[row][column].position = point
                dungeonMap[row][column].lightingBitMask = LightCategory.Hero
                dungeonMap[row][column].zPosition = 2
                
                //Make walls and "nothing" cast shadows
                if (dungeonMap[row][column].tileType == Tile.Wall) || (dungeonMap[row][column].tileType == Tile.Nothing) {
                    dungeonMap[row][column].shadowCastBitMask = LightCategory.Hero
                }
                
                //Let's not add the "nothing" tiles, they hit the CPU way too much...
                if (dungeonMap[row][column].tileType != Tile.Nothing) && (dungeonMap[row][column].tileType != Tile.Ground) {
                    
                    dungeonMap[row][column].removeFromParent()
                    self.addChild(dungeonMap[row][column])
                    
                }

            }
            
        }
        
    }
    

    
    
    //=====================================================================================================//
    //Set the dungeon back to basics
    //
    //=====================================================================================================//
    private func createBlankDungeonMap() -> Void {
        
        for row in 0 ..< dungeonSizeHeight {
            for column in 0 ..< dungeonSizeWidth {
                
                if (column == 0){
                    
                    dungeonMap.append([TileClass(tileToCreate: Tile.Nothing)])
                    
                } else {
                
                    dungeonMap[row].append(TileClass(tileToCreate: Tile.Nothing))
                
                }
            }
        }
    }
    
    


} //End Dungeon class

