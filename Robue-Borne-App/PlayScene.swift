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



//-----------------------------------------------------------------------------------------------//
//
//The main PlayScene...
//
//-----------------------------------------------------------------------------------------------//
class PlayScene: SKScene {
    
    
    
    //-------------------------------------------------------------------------------------------//
    //lets and vars for the class
    //-------------------------------------------------------------------------------------------//

    //Global variables and constants...
    let view2D:SKSpriteNode
    var tiles: [[Int]]
    var dungeonType: String = "cellMap"
    
    
    //JOSH: Pretty sure these are measured in pixels. I think.
    let tileSize = (width:32, height:32)
    
    
    //Init the dungeon, hero, monsters, and dPad control...
    let myDungeon = Dungeon()
    let myHero: Hero
    //let aMonster = DungeonMonster()
    let myDPad: dPad
    
    //To detect the touched node...
    var selectedNode = SKNode()
    
    
    
    //-------------------------------------------------------------------------------------------//
    //INITS and didMoveToView
    //-------------------------------------------------------------------------------------------//

    //Default init in case of errors...
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //Init with the dungeonType (note, not an override since I'm adding attributes)
    init(size: CGSize, dungeonType: String) {
        
        self.view2D = SKSpriteNode()
        self.view2D.userInteractionEnabled = true
        
        self.dungeonType = dungeonType

        self.myDPad = dPad()
        self.myHero = Hero()
        
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
        
        
        //Setup Gestures...
        let gesturePanRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gesturePanRecognizer)
        
        let gesturePinchRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchFrom:"))
        self.view!.addGestureRecognizer(gesturePinchRecognizer)
            
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapFrom:"))
        self.view!.addGestureRecognizer(gestureTapRecognizer)
        
        
        
    
        //Scale the view to ensure all tiles will fit within the view...
        print(self.size)
        
        let yScale = Float(self.size.height) / (Float(myDungeon.dungeonSizeHeight) * Float(tileSize.height))
        let xScale = Float(self.size.width) / (Float(myDungeon.dungeonSizeWidth) * Float(tileSize.width))
        
        print(xScale)
        print(yScale)
        
        view2D.yScale = CGFloat(yScale)
        view2D.xScale = CGFloat(xScale)

        addChild(view2D)
        
        placeAllTiles2D()

        
        //Set the hero
        myHero.position = convertBoardCoordinatetoCGPoint(myHero.location.x, y: myHero.location.y)
        view2D.addChild(myHero)
        
        //Configure and add the d-pad
        myDPad.zPosition = 100
        addChild(myDPad)
    

        
        //Set the background...
        self.backgroundColor = SKColor.grayColor()
        
        
        //Button to return to main menu
        let mainMenuButton = SKLabelNode(fontNamed:"Cochin")
        mainMenuButton.text = "Main Menu"
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.fontSize = 30
        mainMenuButton.fontColor = SKColor.blueColor()
        mainMenuButton.position = CGPoint(x:100, y:720)
        mainMenuButton.zPosition = 100
        addChild(mainMenuButton)
        
    }

    

    //-------------------------------------------------------------------------------------------//
    //
    //The next funcs are used for panning the whole PlayScene...
    //
    //-------------------------------------------------------------------------------------------//
    
    //Callback handler for Pan gestureRecognizer
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        
        selectedNode = view2D
        
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            let position = selectedNode.position
            view2D.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            
            
        } else if recognizer.state == .Ended {
            
            //This "flings" the node on an "end" of a pan
            let scrollDuration = 0.2
            let velocity = recognizer.velocityInView(recognizer.view)
            let pos = selectedNode.position
            
            // This just multiplies your velocity with the scroll duration.
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            let newPos = CGPoint(x: pos.x + p.x, y: pos.y - p.y)
            //newPos = self.boundLayerPos(newPos)
            selectedNode.removeAllActions()
            
            let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
            moveTo.timingMode = .EaseOut
            selectedNode.runAction(moveTo)
        }
    }
    
    
    //used for making sure you don’t scroll the layer beyond the bounds of the background
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(self.size.width) + winSize.width))
        retval.y = CGFloat(min(0, retval.y))
        retval.y = CGFloat(max(-(self.size.height) + winSize.height, retval.y))
        
        return retval
    }
    

    //Used to wiggle the hero as he walks
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    //Handle zooming the entire dungeon
    //
    //-------------------------------------------------------------------------------------------//
    func handlePinchFrom (recognizer: UIPinchGestureRecognizer) {
        
        //The following pinches/zooms the entire view, since the gestures are on PlayScene's (SKScene, which is a node) *SKView* (subclasses of UIView):
        //recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        
        
        //I cribbed the code below and I'm too fucking burnt out to freaking understand it right now...
        //http://stackoverflow.com/questions/21900614/sknode-scale-from-the-touched-point/21947549#21947549
        
        
        //Find out which node was touched
        var touchedAnchorPoint = recognizer.locationInView(recognizer.view)
        touchedAnchorPoint = self.convertPointFromView(touchedAnchorPoint)
        
        
        if (recognizer.state == .Began) {
            
            // No code needed for zooming...
            
        } else if (recognizer.state == .Changed) {

            let anchorPointInMyNode = view2D.convertPoint(anchorPoint, fromNode: self)
            
            view2D.xScale = (view2D.xScale * recognizer.scale)
            view2D.yScale = (view2D.yScale * recognizer.scale)
            
            
            let mySkNodeAnchorPointInScene = self.convertPoint(anchorPointInMyNode, fromNode: view2D)
            
            let translationOfAnchorInScene = CGPointMake(anchorPoint.x - mySkNodeAnchorPointInScene.x, anchorPoint.y - mySkNodeAnchorPointInScene.y)
            
            view2D.position = CGPointMake(view2D.position.x + translationOfAnchorInScene.x, view2D.position.y + translationOfAnchorInScene.y)
            
            recognizer.scale = 1.0
            
        } else if (recognizer.state == .Ended) {
            
            // No code needed here for zooming...
            
        }

        

    }
    
    
    //-------------------------------------------------------------------------------------------//
    //
    //Handle tapping, including d-pad and hero movement
    //
    //-------------------------------------------------------------------------------------------//
    func handleTapFrom (recognizer: UITapGestureRecognizer) {

        //Find which node was touched...
        var touchLocation = recognizer.locationInView(recognizer.view)
        touchLocation = self.convertPointFromView(touchLocation)
        let touchedNode = self.nodeAtPoint(touchLocation)

        
        //D-Pad code goes here...
        if ((touchedNode.name) != nil){
            
            switch touchedNode.name! {
                case "RB_Cntrl_Up":
                    moveHero(0, y:1)
                    //moveMonsters

                case "RB_Cntrl_Down":
                    moveHero(0, y:-1)
                    //moveMonsters
                
                case "RB_Cntrl_Right":
                    moveHero(1, y: 0)
                    //moveMonsters
                
                case "RB_Cntrl_Left":
                    moveHero(-1, y: 0)
                    //moveMonsters
                
                case "RB_Cntrl_Middle": break
                    //rest and move monsters
                
                case "mainMenuButton":
                    //Go back to the StartScene if Main Menu is pressed
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let startScene = StartScene(size: self.size)
                    self.view?.presentScene(startScene, transition: reveal)
                
                default:
                    //Go back to the StartScene if Main Menu is pressed
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let startScene = StartScene(size: self.size)
                    self.view?.presentScene(startScene, transition: reveal)

                
            }
        }
    }

    
    func moveHero(x:Int, y:Int) {
        
        myHero.location.x = myHero.location.x + x
        myHero.location.y = myHero.location.y + y

        let xyPointDiff = convertBoardCoordinatetoCGPoint(myHero.location.x, y:myHero.location.y)
        
        //let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
        //    SKAction.rotateByAngle(0.0, duration: 0.1),
        //    SKAction.rotateByAngle(degToRad(4.0), duration: 0.1),
        //    SKAction.moveTo(xyPointDiff, duration: 0.2)])
        
        myHero.runAction(SKAction.moveTo(xyPointDiff, duration: 0.1))
        
    }
    
    
    
    //-------------------------------------------------------------------------------------------//
    //Tile building...
    //-------------------------------------------------------------------------------------------//
    
    //Generic func to place a tile on the board.
    //Given a board position convert to CGPoint
    //From me: I probably need some conversions of array coordinates to CGPoint coordinate...
    func convertBoardCoordinatetoCGPoint (x: Int, y: Int) -> CGPoint {
        
        let retX = (x * tileSize.width) - (tileSize.width/2)
        let retY = (y * tileSize.height) - (tileSize.height/2)
        
        return CGPoint(x: retX, y: retY)
        
    }
    
    //The following two funcs build the initial board layout
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
    //Touches begin/end -- replaced with touch handlers
    //-------------------------------------------------------------------------------------------//
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        

    }
    
}
