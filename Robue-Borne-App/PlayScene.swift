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
    
    var centerCameraOnPlayer: Bool = false
    
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
    override func didMove(to view: SKView) {

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


    func loadLevelInBackground (withCompletion: @escaping (_ loadingComplete: Bool) -> ()) {
        
        // load resources on other thread
        DispatchQueue.main.async {
            
            //DO MY BACKGROUND LOADING SHIT HERE
            self.loadLevel()
            
            // callback on main thread
            DispatchQueue.main.async(execute: {
                // Call the completion handler back on the main queue.
                withCompletion(true)
            });
        }
    
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
        myDPad.position = CGPoint(x: -620, y:-360)
        //myDPad.xScale = 0.7
        //myDPad.yScale = 0.85
        myCamera.addChild(myDPad)

        
        print("PlayScene Size: ", self.size)
        
        //////////
        //Set the background...
        self.backgroundColor = SKColor(red: 1.0, green: 0.03, blue: 0.01, alpha: 0.5)
        
        
        //////////
        //Button to return to main menu
        let mainMenuButton = GenericRoundSpriteButtonWithName("mainMenuButton", text: "Main Menu")
        mainMenuButton.position = CGPoint(x: -500, y:300)
        myCamera.addChild(mainMenuButton)

        //////////
        //Button to show mini map
        let miniMapButton = GenericRoundSpriteButtonWithName("miniMapButton", text: "Map")
        miniMapButton.position = CGPoint(x: -500, y:250)
        myCamera.addChild(miniMapButton)

        /////////
        //Torch GenericRoundSpriteButton
        let spriteButton = GenericRoundSpriteButtonWithName("torch", text: "Lights")
        spriteButton.position = CGPoint(x: -500, y: 200)
        myCamera.addChild(spriteButton)
        
        
        /////////
        //Build the dungeon
        myDungeonLevel.buildDungeonLevel()
        
        
        /////////
        //Center the dungeon on the hero, then add the dungeon to the scene!
        centerDungeonOnHero(nil)
        
        
        self.addChild(myDungeonLevel)

        
    }//END loadLevel
    
    
    

    //-------------------------------------------------------------------------------------------//
    //
    // PANNING -- The next funcs are used for panning the whole PlayScene...
    //
    //-------------------------------------------------------------------------------------------//
    
    //Callback handler for Pan gestureRecognizer
    func handlePanFrom(_ recognizer: UIPanGestureRecognizer) {

        centerCameraOnPlayer = false
        
        //let selectedNode = myDungeonLevel
        let selectedNode = myCamera
        
        
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            
        } else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
            translation = CGPoint(x: (translation.x * myCamera.xScale), y: (-translation.y * myCamera.yScale))
            
            let position = selectedNode.position
            myCamera.position = CGPoint(x: position.x - translation.x, y: position.y - translation.y)
            
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            
            print("myCamera.position on pan == ", myCamera.position)
            
        } else if recognizer.state == .ended {
            
            //This "flings" the node on an "end" of a pan
            let scrollDuration = 0.2
            let velocity = recognizer.velocity(in: recognizer.view)
            let pos = selectedNode.position
            
            // This just multiplies your velocity with the scroll duration.
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            let newPos = CGPoint(x: pos.x - p.x, y: pos.y + p.y)
            //newPos = self.boundLayerPos(newPos)
            selectedNode.removeAllActions()
            
            let moveTo = SKAction.move(to: newPos, duration: scrollDuration)
            moveTo.timingMode = .easeOut
            selectedNode.run(moveTo)
        }
    }
    
    
    //used for making sure you don’t scroll the layer beyond the bounds of the background
    func boundLayerPos(_ aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(self.size.width) + winSize.width))
        retval.y = CGFloat(min(0, retval.y))
        retval.y = CGFloat(max(-(self.size.height) + winSize.height, retval.y))
        
        return retval
    }
    

    //Used to wiggle the hero as he walks
    func degToRad(_ degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    
    
    
    
    
    //-------------------------------------------------------------------------------------------//
    //
    // ZOOMING the entire dungeon
    //
    //-------------------------------------------------------------------------------------------//
    func handlePinchFrom (_ recognizer: UIPinchGestureRecognizer) {
    
        
        if recognizer.numberOfTouches == 2 {
            
            
            let locationInView = recognizer.location(in: recognizer.view)
            let location = self.convertPoint(fromView: locationInView)
            
            
            if recognizer.state == .changed {
                
                let deltaScale = (recognizer.scale - 1.0)*2
                let convertedScale = recognizer.scale - deltaScale
                let newScale = myCamera.xScale * convertedScale
                myCamera.setScale(newScale)
                
                let locationAfterScale = self.convertPoint(fromView: locationInView)
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
    func handleTapFrom (_ recognizer: UITapGestureRecognizer) {

        //Find which node was touched...
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        let touchedNode = self.atPoint(touchLocation)

        
        //D-Pad code goes here...
        if ((touchedNode.name) != nil){
            
            switch touchedNode.name! {
                case "RB_Cntrl_Up":
                    myDungeonLevel.combatCoordinator.doTurn(heroTurnAction: HeroAction.moveBy(DungeonLocation(x: 0, y: 1)), dungeonLevel: myDungeonLevel)
                    centerCameraOnPlayer = true

                case "RB_Cntrl_Down":
                    myDungeonLevel.combatCoordinator.doTurn(heroTurnAction: HeroAction.moveBy(DungeonLocation(x: 0, y: -1)), dungeonLevel: myDungeonLevel)
                    centerCameraOnPlayer = true
                
                case "RB_Cntrl_Right":
                    myDungeonLevel.combatCoordinator.doTurn(heroTurnAction: HeroAction.moveBy(DungeonLocation(x: 1, y: 0)), dungeonLevel: myDungeonLevel)
                    centerCameraOnPlayer = true

                case "RB_Cntrl_Left":
                    myDungeonLevel.combatCoordinator.doTurn(heroTurnAction: HeroAction.moveBy(DungeonLocation(x: -1, y: 0)), dungeonLevel: myDungeonLevel)
                    centerCameraOnPlayer = true
                
                case "RB_Cntrl_Middle":
                    //rest and move monsters
                    //Temp...
                    scaleDungeonLevelToFitIntoPlayScene()
                    centerCameraOnPlayer = true
                
                case "mainMenuButton":
                    //Go back to the StartScene if Main Menu is pressed
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameScene = SKScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: reveal)
                
                case "miniMapButton":
                    //Popup OR CLOSE the minimap
                    myMiniMap.showMiniMapModal(myDungeonMiniMap: myDungeonLevel, parent: self)
                
                case "hero", "monster", "item":
                    //popup a screen to show the details for the character, monster, or item attributes
                    myDetails.showDetailsModalForNode(touchedNode, parent: self, dungeonLevel: myDungeonLevel)
                
                case "dungeon", "tile", "wall", "ground":
                    //Remove modals
                    //self.childNodeWithName("details")?.removeFromParent()
                    myDetails.hideDetailsModal()
                    myMiniMap.hideMiniMapModal()
                
                case "torch":
                    if myDungeonLevel.heroTorch.isEnabled == false {
                        myDungeonLevel.heroTorch.isEnabled = true
                    } else {
                        myDungeonLevel.heroTorch.isEnabled = false
                    }
                
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
        
        let yScale = (Float(myDungeonLevel.myDungeonMap.dungeonSizeHeight) * Float(tileSize.height)) / Float(self.size.height)
        let xScale = (Float(myDungeonLevel.myDungeonMap.dungeonSizeWidth) * Float(tileSize.width)) / Float(self.size.width)
        
        print("myDungeonLevel.xScale == ", xScale)
        print("myDungeonLevel.yScale == ", yScale)
        print("myDungeonLevel.position == ", myDungeonLevel.position)
        
        myCamera.yScale = CGFloat(yScale)
        myCamera.xScale = CGFloat(xScale)
        
        myCamera.position = CGPoint.zero
        
    }
    

    

    //-------------------------------------------------------------------------------------------//
    //
    // CENTER VIEW on the HERO within myDungeonLevel
    //
    // TODO: Animate the re-positioning of the map, pass an argument for scaling or not
    //
    //-------------------------------------------------------------------------------------------//
    func centerDungeonOnHero(_ scale: Float?) {
        
        let centeredNodePositionInScene = myDungeonLevel.convert(myDungeonLevel.myHero.position, to: self)
        
        myCamera.position = centeredNodePositionInScene
        
        myCamera.xScale = 10
        myCamera.yScale = 10
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
        
        if (centerCameraOnPlayer == true) {
            
            let centeredNodePositionInScene = myDungeonLevel.convert(myDungeonLevel.myHero.position, to: self)

            myCamera.position = centeredNodePositionInScene

        }
        
    }


    
    
} //End PlayScene
