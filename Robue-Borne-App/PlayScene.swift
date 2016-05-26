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
    
    //Init the dungeon level
    let myDungeonLevel: DungeonLevel
    let myDPad: dPad
    let myDetails: CharacterDetailsPopup
    let myMiniMap: MiniMapView
    let myLoadingView: LoadingView
    
    let myCamera: SKCameraNode
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // INITS and didMoveToView
    //
    //-------------------------------------------------------------------------------------------//

    //Default init in case of errors...
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //Init with the dungeonType (NOTE: not an override since I'm adding attributes)
    init(size: CGSize, dungeonType: String) {
        
        
        //INIT UI Elements
        //TODO: Design pattern for naming? Name here or in the init of the class?
        self.myDPad = dPad()
        self.myDetails = CharacterDetailsPopup()
        self.myDetails.name = "details"
        self.myLoadingView = LoadingView()
        self.myMiniMap = MiniMapView()
        
        self.myCamera = SKCameraNode()
        
        //Create the entire dungeon level: map, monsters, heros, et al.
        self.myDungeonLevel = DungeonLevel(dungeonType: dungeonType)
        self.myDungeonLevel.name = "dungeon"
        
        super.init(size: size)

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

        

        //////////
        //Add details window and miniMap, hidden for now
        myCamera.addChild(myDetails)
        myCamera.addChild(myMiniMap)
        myCamera.addChild(myLoadingView)
        
        
        addChild(myCamera)
        self.camera = myCamera
        
        //////////
        //Configure and add the d-pad
        myDPad.zPosition = 100
        myDPad.position = CGPoint(x: -525, y:-400)
        //myDPad.xScale = 0.7
        //myDPad.yScale = 0.85
        myCamera.addChild(myDPad)
        
        
        //////////
        //Position other UI elements
        myMiniMap.position = CGPoint(x: (-(Int(self.size.width / 2))), y: (-(Int(self.size.height) / 2)))
    
        
        //////////
        //Set the background...
        self.backgroundColor = SKColor(red: 0.1, green: 0.01, blue: 0.01, alpha: 1.0)
        
        
        //////////
        //Button to return to main menu
        let mainMenuButton = GenericRoundButtonWithName("mainMenuButton", text: "Main Menu")
        mainMenuButton.position = CGPoint(x: -400, y:325)
        myCamera.addChild(mainMenuButton)
   
        
        //////////
        //Button to show mini map
        let miniMapButton = GenericRoundButtonWithName("miniMapButton", text: "Map")
        miniMapButton.position = CGPoint(x: -400, y:275)
        myCamera.addChild(miniMapButton)

        
        /////////
        //Build dungeon and show loading spinner:
        myLoadingView.showLoadingModal(self)
        myDungeonLevel.buildDungeonLevel()
        myLoadingView.hideLoadingModal()
        
        /////////
        //Center the dungeon on the hero, then add the dungeon to the scene!
        centerDungeonOnHero(nil)

        
        addChild(myDungeonLevel)

    }

    
    
    

    //-------------------------------------------------------------------------------------------//
    //
    // PANNING -- The next funcs are used for panning the whole PlayScene...
    //
    //-------------------------------------------------------------------------------------------//
    
    //Callback handler for Pan gestureRecognizer
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {

        let selectedNode = myDungeonLevel
        
        
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            let position = selectedNode.position
            myDungeonLevel.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            
            print("view2D.position on pan == ", myDungeonLevel.position)
            
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
    
        
/*
        //The following pinches/zooms the entire view, since the gestures are on PlayScene's (SKScene, which is a node) *SKView* (subclasses of UIView):
        //recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        
        
        //I cribbed the code below and I'm too fucking burnt out to freaking understand it right now...
        //http://stackoverflow.com/questions/21900614/sknode-scale-from-the-touched-point/21947549#21947549
        
        
        //Find out which node was touched
        var touchedAnchorPoint = recognizer.locationInView(recognizer.view)
        touchedAnchorPoint = self.convertPointFromView(touchedAnchorPoint)
        
        
        /*
        //CGPoint anchorPoint = [recognizer locationInView:recognizer.view];
        anchorPoint = [self convertPointFromView:anchorPoint];
        */
 
        if (recognizer.state == .Began) {
            
            // No code needed here for zooming...
            
        } else if (recognizer.state == .Changed) {

            //////////
            //debug:
            print("myDungeonLevel.position.x: ", myDungeonLevel.position.x)
            
            
            //////////////////////////////////////////////////////////////////////////////
            /* ... A supposedly correct solution in Objective C ...

             //CGPoint anchorPointInMySkNode = [_mySkNode convertPoint:anchorPoint fromNode:self];
            
            //[_mySkNode setScale:(_mySkNode.xScale * recognizer.scale)];
            
            //CGPoint mySkNodeAnchorPointInScene = [self convertPoint:anchorPointInMySkNode fromNode:_mySkNode];
            //CGPoint translationOfAnchorInScene = CGPointSubtract(anchorPoint, mySkNodeAnchorPointInScene);
            
            _mySkNode.position = CGPointAdd(_mySkNode.position, translationOfAnchorInScene);
            
            //recognizer.scale = 1.0;
            */
            //////////////////////////////////////////////////////////////////////////////
            
            
            let anchorPointInMySkNode = myDungeonLevel.convertPoint(touchedAnchorPoint, fromNode: self)
            
            myDungeonLevel.xScale = (myDungeonLevel.xScale * recognizer.scale)
            
            //This works except for the Y. As soon as I add that, it kablooies.
            //myDungeonLevel.yScale = (myDungeonLevel.yScale + recognizer.scale)
            
            let mySkNodeAnchorPointInScene = self.convertPoint(anchorPointInMySkNode, fromNode: myDungeonLevel)
            let translationOfAnchorInScene = touchedAnchorPoint - mySkNodeAnchorPointInScene
            
            myDungeonLevel.position = myDungeonLevel.position + translationOfAnchorInScene
            
            
            recognizer.scale = 1.0

    
            //////////
            //debug:
            print ("recognizer.scale == ", recognizer.scale)

            
        } else if (recognizer.state == .Ended) {
            
            // No code needed here for zooming...
            //centerDungeonOnHero(1)
        }

*/
        
        
        
        if recognizer.numberOfTouches() == 2 {
            
            
            let locationInView = recognizer.locationInView(recognizer.view)
            let location = self.convertPointFromView(locationInView)
            
            
            if recognizer.state == .Changed {
                
                let deltaScale = (recognizer.scale - 1.0)*2
                let convertedScale = recognizer.scale - deltaScale
                let newScale = myCamera.xScale * convertedScale
                myCamera.setScale(newScale)
                
                let locationAfterScale = self.convertPointFromView(locationInView)
                let locationDelta = location - locationAfterScale
                let newPoint = myCamera.position + locationDelta
                myCamera.position = newPoint
                
                recognizer.scale = 1.0
                
            }
            
            
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
                    myDungeonLevel.moveHero(0, y: 1)
                    myDungeonLevel.moveMonster()
                
                case "RB_Cntrl_Down":
                    myDungeonLevel.moveHero(0, y: -1)
                    myDungeonLevel.moveMonster()
                
                case "RB_Cntrl_Right":
                    myDungeonLevel.moveHero(1, y: 0)
                    myDungeonLevel.moveMonster()

                
                case "RB_Cntrl_Left":
                    myDungeonLevel.moveHero(-1, y: 0)
                    myDungeonLevel.moveMonster()

                
                case "RB_Cntrl_Middle":
                    //rest and move monsters
                    //Temp...
                    scaleDungeonLevelToFitIntoPlayScene()
                
                
                case "mainMenuButton":
                    //Go back to the StartScene if Main Menu is pressed
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let startScene = StartScene(size: self.size)
                    self.view?.presentScene(startScene, transition: reveal)
                
                
                case "miniMapButton":
                    //Popup OR CLOSE the minimap
                    myMiniMap.showMiniMapModal(myDungeonLevel.myDungeonMap, parent: self)
                
                
                
                case "hero", "monster", "item":
                    //popup a screen to show the details for the character, monster, or item attributes
                    myDetails.showDetailsModalForNode(touchedNode, parent: self)
                
                
                case "dungeon", "tile", "wall", "ground":
                    //Remove modals
                    //self.childNodeWithName("details")?.removeFromParent()
                    myDetails.hideDetailsModal()
                    myMiniMap.hideMiniMapModal()
                
                
                default:
                    //Remove modals
                    //self.childNodeWithName("details")?.removeFromParent()
                    myDetails.hideDetailsModal()
                    myMiniMap.hideMiniMapModal()
                
            }
        }
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // SCALE and FIT the view into the screen space -- myDungeonLevel
    //
    //-------------------------------------------------------------------------------------------//
    
    func scaleDungeonLevelToFitIntoPlayScene () {
        
        //Scale the view to ensure all tiles will fit within the view...
        print("PlayScene.size == ", self.size)
        
        let yScale = Float(self.size.height) / (Float(myDungeonLevel.myDungeonMap.dungeonSizeHeight) * Float(tileSize.height))
        let xScale = Float(self.size.width) / (Float(myDungeonLevel.myDungeonMap.dungeonSizeWidth) * Float(tileSize.width))
        
        print("myDungeonLevel.xScale == ", xScale)
        print("myDungeonLevel.yScale == ", yScale)
        print("myDungeonLevel.position == ", myDungeonLevel.position)
        
        myDungeonLevel.yScale = CGFloat(yScale)
        myDungeonLevel.xScale = CGFloat(xScale)
        
        myDungeonLevel.position = CGPointZero
        
    }
    

    

    //-------------------------------------------------------------------------------------------//
    //
    // CENTER VIEW on the HERO within myDungeonLevel
    //
    // TODO: Animate the re-positioning of the map, pass an argument for scaling or not
    //
    //-------------------------------------------------------------------------------------------//
    
    func centerDungeonOnHero(scale: Float?) {
        
        //GOOD GOD THIS TOOK WAY TOO MUCH TIME BECAUSE I CAN"T FUCKING FOCUS. FUCK. I STILL DON'T THINK IT'S RIGHT. AND FUCK THE SHIFT KEY< I SHOULD BE ABLE TO HOLD IT DOWN AND GET APPROPRIATE PUNCTUATION WHEN I"M FUCKING YELLING YOU FUCKING FUCK SHIT OF A FUCK>
        
        print("myDungeonLevel.myDungeonMap.position ==  ", myDungeonLevel.myDungeonMap.position)
        print("myDungeonLevel.position == ", myDungeonLevel.position)
        print("myDungeonLevel.size", myDungeonLevel.calculateAccumulatedFrame())
        print("self.size == ", self.size)
        
        let centeredNodePositionInScene = myDungeonLevel.convertPoint(myDungeonLevel.myHero.position, toNode: self)
        
        let myDungeonLevel2DFrame = myDungeonLevel.calculateAccumulatedFrame()
        
        var newDungeonLevelPosition = CGPoint()
        
        newDungeonLevelPosition.x = -((centeredNodePositionInScene.x / myDungeonLevel2DFrame.width) * self.size.width)
        newDungeonLevelPosition.y = -((centeredNodePositionInScene.y / myDungeonLevel2DFrame.height) * self.size.height)
        
        myDungeonLevel.position = newDungeonLevelPosition
        
        print("newDungeonLevelPosition == ", newDungeonLevelPosition)
        print("myDungeonLevel.position == ", myDungeonLevel.position)
        
        if (scale == nil) {
            myDungeonLevel.xScale = 0.5
            myDungeonLevel.yScale = 0.5
        }
        
    }

    
    
} //End PlayScene
