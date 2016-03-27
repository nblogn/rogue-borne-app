//
//  PlayScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/13/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit




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
    var dungeonType: String = "cellMap"
    
    
    //JOSH: Pretty sure these are measured in pixels. I think.
    let tileSize = (width:32, height:32)
    
    
    //Init the dungeon, hero, monsters, and dPad control...
    let myDungeon = Dungeon()
    let myHero: Hero
    //let aMonster = DungeonMonster()
    let myDPad: dPad
    
    //Add a light source for the hero...
    var ambientColor:UIColor?
    var light = SKLightNode();
    
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
            case "bigBangMap": myDungeon.generateDungeonRoomsUsingFitLeftToRight()
            default:myDungeon.createDungeonUsingCellMethod()
        }
        
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
        view2D.lightingBitMask = 1

        addChild(view2D)
        
        //placeAllTiles2D()
        placeAllDungeonTiles()
        
        //Set the hero
        myHero.location.x = myDungeon.dungeonRooms[0].location.x1+1
        myHero.location.y = myDungeon.dungeonRooms[0].location.y1+1
        myHero.position = convertBoardCoordinatetoCGPoint(myHero.location.x, y: myHero.location.y)
        view2D.addChild(myHero)
        
        
        //Set the hero's light:
        light.position = CGPointMake(0,0)
        light.falloff = 1
        
        //Kind of prefer it with this off:
        //light.ambientColor = UIColor.darkGrayColor()

        light.lightColor = UIColor.redColor()
        myHero.addChild(light)
        
        
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
        
        switch myDungeon.dungeonMap[myHero.location.y + y][myHero.location.x + x] {
            
        case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
            myHero.location.x = myHero.location.x + x
            myHero.location.y = myHero.location.y + y

            let xyPointDiff = convertBoardCoordinatetoCGPoint(myHero.location.x, y:myHero.location.y)
            
            //let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
            //    SKAction.rotateByAngle(0.0, duration: 0.1),
            //    SKAction.rotateByAngle(degToRad(4.0), duration: 0.1),
            //    SKAction.moveTo(xyPointDiff, duration: 0.2)])
            
            myHero.runAction(SKAction.moveTo(xyPointDiff, duration: 0.1))
            
        default: break
        }
        
    }
    
    
    
    //-------------------------------------------------------------------------------------------//
    //Tile building...
    //-------------------------------------------------------------------------------------------//
    
    //Generic func to place a tile on the board.
    //Given a board position convert to CGPoint
    //From me: I probably need some conversions of array coordinates to CGPoint coordinate...
    func convertBoardCoordinatetoCGPoint (x: Int, y: Int) -> CGPoint {
        
        let retX = ((x+1) * tileSize.width) - (tileSize.width/2)
        let retY = ((y+1) * tileSize.height) - (tileSize.height/2)
        
        return CGPoint(x: retX, y: retY)
        
    }
    
    
    
    //TODO: USE THIS TO REPLACE THER ONE BELOW, and the "tiles" object, it's not needed.
    //Also, use this to setup shadowedBitMask on walls, etc.
    func placeAllDungeonTiles(){
    
        //Loop through all tiles
        for row in 0..<myDungeon.dungeonMap.count {
            
            for column in 0..<myDungeon.dungeonMap[row].count {
                
                let aTile = myDungeon.dungeonMap[row][column]
                
                //Stack each tileSprite in a grid, left to right, then top to bottom. Note: in the SpriteKit coordinate system, 
                //y values increase as you move up the screen and decrease as you move down.
                let point = CGPoint(x: (column*tileSize.width), y: (row*tileSize.height))
                
                let tileSprite = SKSpriteNode(imageNamed: aTile.image)
                
                tileSprite.position = point
                
                tileSprite.anchorPoint = CGPoint(x:0, y:0)
                
                tileSprite.lightingBitMask = 1
                
                
                if (aTile == Tile.Wall) || (aTile == Tile.Nothing) {
                    tileSprite.shadowCastBitMask = 1
                    //tileSprite.anchorPoint =
                }
                
                view2D.addChild(tileSprite)
            }
            
        }
    
    }
    
    
    
    //-------------------------------------------------------------------------------------------//
    //Touches begin/end -- replaced with touch handlers
    //-------------------------------------------------------------------------------------------//
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        

    }
    
}
