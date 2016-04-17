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
    //
    //lets and vars for the class
    //
    //-------------------------------------------------------------------------------------------//
    //Global variables and constants...
    let view2D:SKSpriteNode
    
    //JOSH: Pretty sure these are measured in pixels.
    let tileSize = (width:32, height:32)
    
    
    //Init the dungeon, hero, monsters, and dPad control...
    let myDungeon = Dungeon()
    let myHero: Hero
    let aMonster: Monster
    let myDPad: dPad
    let myDetails: CharacterDetailsPopup
    
    //Add a light source for the hero...
    var ambientColor:UIColor?
    var heroTorch = SKLightNode();
    var dungeonLight = SKLightNode();
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // INITS and didMoveToView
    //
    //-------------------------------------------------------------------------------------------//

    //Default init in case of errors...
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //Init with the dungeonType (note, not an override since I'm adding attributes)
    init(size: CGSize, dungeonType: String) {
        
        self.view2D = SKSpriteNode()
        self.view2D.userInteractionEnabled = true
        
        self.myDPad = dPad()
        self.myHero = Hero()
        self.aMonster = Monster()
        self.myDetails = CharacterDetailsPopup()
        myDetails.name = "details"
        
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

        ////
        //Setup Gestures...
        let gesturePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PlayScene.handlePanFrom(_:)))
        self.view!.addGestureRecognizer(gesturePanRecognizer)
        
        let gesturePinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PlayScene.handlePinchFrom(_:)))
        self.view!.addGestureRecognizer(gesturePinchRecognizer)
            
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlayScene.handleTapFrom(_:)))
        self.view!.addGestureRecognizer(gestureTapRecognizer)

        
        ////
        //Add the dungeon to the view2D node, and add the view2D node to the PlayScene scene.
        view2D.addChild(myDungeon)
        addChild(view2D)
        
        ////
        //Add details window, hidden for now
        addChild(myDetails)
        
        ////
        //Set the hero
        myHero.location.x = myDungeon.dungeonRooms[0].location.x1+1
        myHero.location.y = myDungeon.dungeonRooms[0].location.y1+1
        myHero.position = convertBoardCoordinatetoCGPoint(myHero.location.x, y: myHero.location.y)
        view2D.addChild(myHero)
        
        //Set the hero's light:
        heroTorch.position = CGPointMake(0.25,0.25)
        //Kind of prefer it with this off, but leaving it on to see monsters:
        //heroTorch.ambientColor = UIColor.brownColor()
        //heroTorch.falloff = 1
        heroTorch.lightColor = UIColor.redColor()
        heroTorch.enabled = true
        heroTorch.categoryBitMask = LightCategory.Hero
        myHero.addChild(heroTorch)
        
        view2D.lightingBitMask = LightCategory.Hero
        
        
        ////
        //Set the monster
        aMonster.location.x = myDungeon.dungeonRooms[0].location.x1+1
        aMonster.location.y = myDungeon.dungeonRooms[0].location.y1+2
        aMonster.position = convertBoardCoordinatetoCGPoint(aMonster.location.x, y: aMonster.location.y)

        //Added a shadow to the monster
        aMonster.shadowCastBitMask = LightCategory.Hero
        view2D.addChild(aMonster)

        //Light the monster on fire
        if let particles = SKEmitterNode(fileNamed: "FireParticle.sks") {
            //particles.position = player.position
            aMonster.addChild(particles)
        }


        
        ////
        //Configure and add the d-pad
        myDPad.zPosition = 99
        addChild(myDPad)
    
        
        ////
        //Set the background...
        self.backgroundColor = SKColor(red: 0.1, green: 0.01, blue: 0.01, alpha: 1.0)
        
        
        ////
        //Button to return to main menu
        let mainMenuButton = SKShapeNode()
        mainMenuButton.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 160, height: 60), cornerRadius: 8).CGPath
        mainMenuButton.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        mainMenuButton.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        mainMenuButton.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        mainMenuButton.lineWidth = 2
        mainMenuButton.glowWidth = 3
        mainMenuButton.zPosition = 99
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.position = CGPoint(x: 20, y:675)
        
        let mainMenuButtonText = SKLabelNode(fontNamed:"Cochin")
        mainMenuButtonText.text = "Main Menu"
        mainMenuButtonText.name = "mainMenuButtonText"
        mainMenuButtonText.fontSize = 28
        mainMenuButtonText.fontColor = SKColor.whiteColor()
        mainMenuButtonText.position = CGPoint(x:80, y:20)
        mainMenuButtonText.zPosition = 100
        
        mainMenuButton.addChild(mainMenuButtonText)
        
        addChild(mainMenuButton)
        
    }

    
    
    

    //-------------------------------------------------------------------------------------------//
    //
    // PANNING -- The next funcs are used for panning the whole PlayScene...
    //
    //-------------------------------------------------------------------------------------------//
    
    //Callback handler for Pan gestureRecognizer
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {

        let selectedNode = view2D
        
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
    // ZOOMING the entire dungeon
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

            //////////
            //Position:
            print("view2D.position.x: ", view2D.position.x)
            
            let view2dBounds: CGRect = view2D.calculateAccumulatedFrame()
            let view2dMidpoint: CGPoint = CGPoint(x: ((view2dBounds.width - view2D.position.x)/2), y: ((view2dBounds.height - view2D.position.y)/2))
            let view2dMidpointInScene = view2D.convertPoint(view2dMidpoint, fromNode: self)
            
            
            if recognizer.scale > 1 { //zooming out
                
                if touchedAnchorPoint.x < view2dMidpointInScene.x {
                    view2D.position.x += 10 * recognizer.scale
                } else {
                    view2D.position.x -= 10 * recognizer.scale
                }
                
                if touchedAnchorPoint.y < view2dMidpointInScene.y {
                    view2D.position.y += 7 * recognizer.scale
                } else {
                    view2D.position.y -= 7 * recognizer.scale
                }
                
            } else { //zooming in
                
                if touchedAnchorPoint.x < view2dMidpointInScene.x {
                    view2D.position.x -= 10 * recognizer.scale
                } else {
                    view2D.position.x += 10 * recognizer.scale
                }
                
                if touchedAnchorPoint.y < view2dMidpointInScene.y {
                    view2D.position.y -= 7 * recognizer.scale
                } else {
                    view2D.position.y += 7 * recognizer.scale
                }

            }
    
            
            //////////
            //Scale:
            print ("recognizer.scale == ", recognizer.scale)
            
            view2D.xScale = (view2D.xScale * recognizer.scale)
            view2D.yScale = (view2D.yScale * recognizer.scale)

            recognizer.scale = 1.0
            
        } else if (recognizer.state == .Ended) {
            
            // No code needed here for zooming...
            
        }

        

    }
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // TAPPING, including d-pad and hero movement
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
                    moveMonster()

                case "RB_Cntrl_Down":
                    moveHero(0, y:-1)
                    moveMonster()
                
                case "RB_Cntrl_Right":
                    moveHero(1, y: 0)
                    moveMonster()
                
                case "RB_Cntrl_Left":
                    moveHero(-1, y: 0)
                    moveMonster()
                
                case "RB_Cntrl_Middle": break
                    //rest and move monsters
                
                case "mainMenuButton":
                    //Go back to the StartScene if Main Menu is pressed
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let startScene = StartScene(size: self.size)
                    self.view?.presentScene(startScene, transition: reveal)
                
                case "hero", "monster", "item":
                    //popup a screen to show the details for the character, monster, or item attributes
                    //addChild(myDetails)
                    myDetails.showDetailsModalForNode(touchedNode, parent: self)
                
                default:
                    //Go back to the StartScene if Main Menu is pressed
                    //self.childNodeWithName("details")?.removeFromParent()
                    myDetails.hideDetailsModal ()
            }
        }
    }
    
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // MOVE characters and monsters
    //
    //-------------------------------------------------------------------------------------------//

    func moveHero(x:Int, y:Int) {
        
        switch myDungeon.dungeonMap[myHero.location.y + y][myHero.location.x + x].tileType {
            
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
    
    
    func moveMonster() -> Void {
        // Let's just move randomly for now.
        // Pick a cardinal direction and check for collision
        // Repeat until a successful move has occurred or
        // the number of tries reaches 5. Dude could be trapped
        // like a Piner in a closet and we don't want to hang
        // JOSH: LOL!
        
        var hasMoved: Bool=false
        var numTries: Int=0
        var direction: Int
        
        
        while ( hasMoved == false ) && ( numTries < 5) {
            
            direction = Int(arc4random_uniform(4))
            
            
            switch direction {
            case 0:
                // Try north
            
                    switch myDungeon.dungeonMap[aMonster.getCurrentLocation().y-1][aMonster.getCurrentLocation().x].tileType  {
                        
                    case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                        aMonster.setCurrentLocation(aMonster.getCurrentLocation().x, Y: aMonster.getCurrentLocation().y-1)
                        hasMoved = true
                    default:
                        break
                    }
                
            case 1:
                // Try south
              
                    switch myDungeon.dungeonMap[aMonster.getCurrentLocation().y+1][aMonster.getCurrentLocation().x].tileType {
                        
                    case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                        aMonster.setCurrentLocation(aMonster.getCurrentLocation().x, Y: aMonster.getCurrentLocation().y+1)
                        hasMoved = true
                    default:
                        break
                    }
                
                
            case 2:
                // Try east
               
                    switch myDungeon.dungeonMap[aMonster.getCurrentLocation().y][aMonster.getCurrentLocation().x-1].tileType {
                        
                    case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                        aMonster.setCurrentLocation(aMonster.getCurrentLocation().x-1, Y: aMonster.getCurrentLocation().y)
                        hasMoved = true
                    default:
                        break
                    }
               
                
            case 3:
                // Try west
                
                    switch myDungeon.dungeonMap[aMonster.getCurrentLocation().y][aMonster.getCurrentLocation().x+1].tileType {
                        
                    case .Door, .CorridorHorizontal, .CorridorVertical, .Grass, .Ground:
                        aMonster.setCurrentLocation(aMonster.getCurrentLocation().x+1, Y: aMonster.getCurrentLocation().y)
                        hasMoved = true
                    default:
                        break
                    }
               
                
            default:
                
                print("Fell through monster move switch")
            }
            
            numTries += 1
        }
        
        let xyPointDiff = convertBoardCoordinatetoCGPoint(aMonster.location.x, y:aMonster.location.y)
        
        aMonster.runAction(SKAction.moveTo(xyPointDiff, duration: 0.1))
        
    }

    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // SCALE and FIT the view into the screen space:
    //
    // Turning this off, as it's actually nice to start zoomed in. Note this might make a good func for double tap
    //
    //-------------------------------------------------------------------------------------------//
    
    func scaleToFitViewIntoScene () {
        
        //Scale the view to ensure all tiles will fit within the view...
        print("PlayScene.size== ", self.size)
        
        let yScale = Float(self.size.height) / (Float(myDungeon.dungeonSizeHeight) * Float(tileSize.height))
        let xScale = Float(self.size.width) / (Float(myDungeon.dungeonSizeWidth) * Float(tileSize.width))
        
        print("PlayScene xScale== ", xScale)
        print("PlayScene yScale== ", yScale)
        
        view2D.yScale = CGFloat(yScale)
        view2D.xScale = CGFloat(xScale)

    }


 
 
 
    //-------------------------------------------------------------------------------------------//
    //Handling board coordinate space
    //Generic func to place a tile on the board.
    //Given a board position convert to CGPoint
    //From me: I probably need some conversions of array coordinates to CGPoint coordinate...
    //-------------------------------------------------------------------------------------------//
    func convertBoardCoordinatetoCGPoint (x: Int, y: Int) -> CGPoint {
        
        let retX = ((x+1) * tileSize.width) - (tileSize.width/2)
        let retY = ((y+1) * tileSize.height) - (tileSize.height/2)
        
        return CGPoint(x: retX, y: retY)
        
    }
    
    
}
