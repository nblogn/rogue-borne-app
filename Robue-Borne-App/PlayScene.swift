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
    let myLoadingNode: LoadingNode
    
    let myCamera: SKCameraNode
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // INITS and didMoveToView
    //  Note the loading splash screen as the background sets up the level.
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
        self.myLoadingNode = LoadingNode()
        self.myMiniMap = MiniMapView()
        
        self.myCamera = SKCameraNode()
        
        //Create the entire dungeon level: map, monsters, heros, et al.
        self.myDungeonLevel = DungeonLevel(dungeonType: dungeonType)
        self.myDungeonLevel.name = "dungeon"
        
        super.init(size: size)

    }
    
    
    //didMoveToView is the first event in the PlayScene after inits
    override func didMoveToView(view: SKView) {

        //////////
        //Setup the camera
        addChild(myCamera)
        self.camera = myCamera

        
        //////////
        //Create a loading animation to display as the dungeon is being built (it can take a few seconds).
        myCamera.addChild(myLoadingNode)
        myLoadingNode.showLoadingModal(self)
        myLoadingNode.position = CGPoint(x: -Int(self.size.width / 2), y: -Int(self.size.height / 2))

        
        
        //Do what it says
        loadLevelInBackground(){
            
            (loadingComplete: Bool) in
            
            if loadingComplete == true {
                self.myLoadingNode.hideLoadingModal()
            }
            
        }

    }


    func loadLevelInBackground (withCompletion: (loadingComplete: Bool) -> ()) {
        
        // load resources on other thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            //DO MY BACKGROUND LOADING SHIT HERE
            self.loadLevel()
            
            // callback on main thread
            dispatch_async(dispatch_get_main_queue(), {
                // Call the completion handler back on the main queue.
                withCompletion(loadingComplete: true)
            });
        })
    
    }
    
    
    func loadLevel () {

        
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
        myMiniMap.position = CGPoint(x: 0, y: 0)
        
        
        //////////
        //Configure and add the d-pad
        myDPad.zPosition = 100
        myDPad.position = CGPoint(x: -525, y:-400)
        //myDPad.xScale = 0.7
        //myDPad.yScale = 0.85
        myCamera.addChild(myDPad)
        
        
        
        //////////
        //Set the background...
        self.backgroundColor = SKColor(red: 0.1, green: 0.01, blue: 0.01, alpha: 1.0)
        
        
        //////////
        //Button to return to main menu
        let mainMenuButton = GenericRoundButtonWithName("mainMenuButton", text: "Main Menu")
        mainMenuButton.position = CGPoint(x: -400, y:300)
        myCamera.addChild(mainMenuButton)
        
        
        
        /////////
        //Testing SgButton Class
        let btn31 = SgButton(normalString: "SgButton Test", normalStringColor: UIColor.blueColor(), normalFontName: "Cochin", normalFontSize: 25, backgroundNormalColor: UIColor.yellowColor(), size: CGSizeMake(200, 40), cornerRadius: 10.0, buttonFunc: self.tappedButton)
        btn31.setString(.Highlighted, string: "Being tapped", stringColor: UIColor.redColor(), backgroundColor: UIColor.greenColor())
        btn31.position = CGPoint(x: -400, y: 200)
        btn31.tag = 31
        myCamera.addChild(btn31)
        
        
        /////////
        //Testing new GenericRoundSpriteButton
        let spriteButton = GenericRoundSpriteButtonWithName("test", text: "sprite btn")
        spriteButton.position = CGPoint(x: -400, y: 100)
        myCamera.addChild(spriteButton)
        
        
        //////////
        //Button to show mini map
        let miniMapButton = GenericRoundButtonWithName("miniMapButton", text: "Map")
        miniMapButton.position = CGPoint(x: -400, y:250)
        myCamera.addChild(miniMapButton)
        
        
        /////////
        //Build the dungeon
        myDungeonLevel.buildDungeonLevel()
        
        
        /////////
        //Center the dungeon on the hero, then add the dungeon to the scene!
        centerDungeonOnHero(nil)
        
        
        addChild(myDungeonLevel)

        
    }//END loadLevel
    
    
    

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
                
                    //test
                    //myLoadingView.showLoadingModal(self)
                
                
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
    
    
    
    func tappedButton(button: SgButton) {
        print("tappedButton tappedButton tag=\(button.tag)")

        myMiniMap.showMiniMapModal(myDungeonLevel.myDungeonMap, parent: self)

        
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
        
        let centeredNodePositionInScene = myDungeonLevel.convertPoint(myDungeonLevel.myHero.position, toNode: self)
        
        myCamera.position = centeredNodePositionInScene
        
        if (scale == nil) {
            myDungeonLevel.xScale = 0.5
            myDungeonLevel.yScale = 0.5
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        
        let centeredNodePositionInScene = myDungeonLevel.convertPoint(myDungeonLevel.myHero.position, toNode: self)

        myCamera.position = centeredNodePositionInScene
        
    }


    
    
} //End PlayScene
