//
//  PlayScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/13/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


//-------------------------------------------------------------------------------------------//
//
//HANDY FUNCs I'm Probably going to need go here...
//Grabbed these from the SK tutorial here
//http://www.raywenderlich.com/119815/sprite-kit-swift-2-tutorial-for-beginners
//
//-------------------------------------------------------------------------------------------//

//From me: I probably need some conversions of array coordinates to CGPoint coordinate...
func convertBoardCoordinatetoCGPoint () -> CGPoint {

    //bogus placeholder code
    let cgpoint = CGPoint(x: 1,y: 2)
    return cgpoint
}


/*Note: You may be wondering what the fancy syntax is here. Note that the category on Sprite Kit is just a single 32-bit integer, and acts as a bitmask. This is a fancy way of saying each of the 32-bits in the integer represents a single category (and hence you can have 32 categories max). Here you’re setting the first bit to indicate a monster, the next bit over to represent a projectile, and so on.*/
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1
    static let Projectile: UInt32 = 0b10
}


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


//-------------------------------------------------------------------------------------------//
//
//Note, a lot of this tile code comes from the following tutorial
//http://bigspritegames.com/isometric-tile-based-game-part-1/
//
//TODO: This should be in the Dungeon class. I think.
//
//-------------------------------------------------------------------------------------------//

enum Tile: Int {
    
    case Ground
    case Wall
    case Nothing
    case Grass
    
    var description:String {
        switch self {
        case Ground:
            return "Ground"
        case Wall:
            return "Wall"
        case Nothing:
            return "Nothing"
        case Grass:
            return "RB_Grass_2x"

        }
    }
    
    var image:String {
        switch self {
        case Ground:
            return "RB_Floor_Green_2x"
        case Wall:
            return "RB_Wall_2x"
        case Nothing:
            return "RB_Floor_Grey_2x"
        case Grass:
            return "RB_Grass_2x"
            
        }
    } 
}



//-------------------------------------------------------------------------------------------//
//
//The main PlayScene...
//
//-------------------------------------------------------------------------------------------//
class PlayScene: SKScene {
    
    
    
    //-------------------------------------------------------------------------------------------//
    //lets and vars for the class
    //-------------------------------------------------------------------------------------------//

    //Global variables and constants...
    let view2D:SKSpriteNode
    let viewIso:SKSpriteNode
    
    
    var tiles: [[Int]]
    var dungeonType: String = "cellMap"
    
    
    //JOSH: Sounds simple, but what measurement is this? Pixels? Arbitrary unit?
    let tileSize = (width:32, height:32)
    
    let myDungeon = Dungeon()
    
    var selectedNode = SKSpriteNode()
    
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //INITS and didMoveToView
    //-------------------------------------------------------------------------------------------//

    //Default init in case of errors...
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Override without anything else
    override init(size: CGSize) {
        
        viewIso = SKSpriteNode()
        view2D = SKSpriteNode()
        
        myDungeon.generateDungeonRoomsUsingBigBang()
        tiles = myDungeon.dungeonMap

        super.init(size: size)
        
    }

    //Override with the dungeonType
    init(size: CGSize, dungeonType: String) {
        
        view2D = SKSpriteNode()
        view2D.userInteractionEnabled = true
        
        viewIso = SKSpriteNode()
        
        self.dungeonType = dungeonType
        
        
        //Change the different map creation algorithms to happen on UI button press
        switch dungeonType {
        case "cellMap": myDungeon.createDungeonUsingCellMethod()
        case "cellAutoMap": myDungeon.generateDungeonRoomUsingCellularAutomota()
        case "bigBangMap": myDungeon.generateDungeonRoomsUsingBigBang()
        default:myDungeon.createDungeonUsingCellMethod()
        }
        
        tiles = myDungeon.dungeonMap

        super.init(size: size)
        self.anchorPoint = CGPoint(x:0, y:0)

    }
    
    
    //didMoveToView is the first event in the PlayScene after inits
    override func didMoveToView(view: SKView) {
        
        let deviceScale:CGFloat = 1 //self.size.width/667
        
        let gesturePanRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gesturePanRecognizer)
        
        let gesturePinchRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchFrom:"))
        self.view!.addGestureRecognizer(gesturePinchRecognizer)
            
        
        //view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        
        placeAllTiles2D()
        
        
        self.backgroundColor = SKColor.redColor()
        
        //Button to return to main menu
        let mainMenuButton = SKLabelNode(fontNamed:"Cochin")
        mainMenuButton.text = "Main Menu"
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.fontSize = 30
        mainMenuButton.fontColor = SKColor.blueColor()
        mainMenuButton.position = CGPoint(x:150, y:20)
        mainMenuButton.zPosition = 100
        addChild(mainMenuButton)
        
    }

    

    //-------------------------------------------------------------------------------------------//
    //
    //The next funcs are used for panning the whole PlayScene...
    //
    //-------------------------------------------------------------------------------------------//
    
    //used for making sure you don’t scroll the layer beyond the bounds of the background
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(self.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    
    func panForTranslation(translation: CGPoint) {
        
        let position = view2D.position
        
        //Eventually I can add an if here to move a specific sprite instead of the entire view2D node.
        //if selectedNode.name! == "" {}
        
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        view2D.position = self.boundLayerPos(aNewPosition)
        
    }
    
    
    //Callback handler for gestureRecognizer
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            selectNodeForTouch(touchLocation)
            
            
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            
            
        } else if recognizer.state == .Ended {
            
            //This "flings" the node on an "end" of a pan
            let scrollDuration = 0.2
            let velocity = recognizer.velocityInView(recognizer.view)
            let pos = selectedNode.position
            
            // This just multiplies your velocity with the scroll duration.
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
            newPos = self.boundLayerPos(newPos)
            selectedNode.removeAllActions()
            
            let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
            moveTo.timingMode = .EaseOut
            selectedNode.runAction(moveTo)
        }
    }

    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }

    
    //Figure out which node was selected (eg, the character, or just the whole background, etc.)
    func selectNodeForTouch(touchLocation: CGPoint) {
        
        // Use this to select a character SKSpriteNode

        let touchedNode = self.nodeAtPoint(touchLocation)
    
        if touchedNode is SKSpriteNode {
            
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                //Make the selected node shake around
                let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                    SKAction.rotateByAngle(0.0, duration: 0.1),
                    SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                selectedNode.runAction(SKAction.repeatActionForever(sequence))
                
                //Make View move FOR TESTING
                let sequence2 = SKAction.sequence([SKAction.scaleBy(0.5, duration: 1)])
                view2D.runAction(SKAction.repeatActionForever(sequence2))

                
            }
        } else {
            
            if touchedNode.name == "mainMenuButton" {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let startScene = StartScene(size: self.size)
                self.view?.presentScene(startScene, transition: reveal)
            }
        }
        
        //Reset selectedNode to be view2D for now, for testing purposes...
        selectedNode = view2D
        
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //Handle zooming the tiles
    //-------------------------------------------------------------------------------------------//

    func handlePinchFrom (recognizer: UIPinchGestureRecognizer) {
        
        
        //THIS IS PINCHING THE ENTIRE VIEW, NOT THE VIEW2D NODE!!!
        recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1.0

    }
    
    
    //-------------------------------------------------------------------------------------------//
    //Tile building...
    //-------------------------------------------------------------------------------------------//
    func placeAllTiles2D() {
        
        //Loop through all tiles
        for i in 0..<tiles.count {
            
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tileInt = row[j]
                
                //Assign a new Tile enum, setting it’s type via the id value, e.g. because we used an enum for our Tile, 0 = Ground, 1 = Wall
                let tile = Tile(rawValue: tileInt)!
                
                //Stack each tileSprite in a grid, left to right, then top to bottom. Note: in the SpriteKit coordinate system, y values increase as you move up the screen and decrease as you move down.
                let point = CGPoint(x: (j*tileSize.width), y: (i*tileSize.height))
                
                placeTile2D(tile.image, withPosition:point)
            }
            
        }
        
    }
    

    func placeTile2D(image:String, withPosition:CGPoint) {
        
        let tileSprite = SKSpriteNode(imageNamed: image)
        
        tileSprite.position = withPosition
        
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        
        view2D.addChild(tileSprite)
        
    }
    
    
    
    
    

    //-------------------------------------------------------------------------------------------//
    //Called when a touch stops; so using this to go back to main menu (GameScene) on a press
    //TODO: Replace with a button or a gesture
    //-------------------------------------------------------------------------------------------//
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /*
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let startScene = StartScene(size: self.size)
        self.view?.presentScene(startScene, transition: reveal)
        */
    }
    
}
