//
//  GameScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright (c) 2016 nblogn.com. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        //self.backgroundColor = SKColor(red: 0.13, green: 0.1, blue: 0.15, alpha: 0.9)
        
        
        let gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleTapFrom(_:)))
        self.view!.addGestureRecognizer(gestureTapRecognizer)

        
        let createCellMapButton = GenericRoundSpriteButtonWithName("cellMapButton", text: "Create a Cell Map")
        createCellMapButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-20)
        self.addChild(createCellMapButton)
        
        
        let createCellAutoMapButton = GenericRoundSpriteButtonWithName("cellAutoMapButton", text: "Create a Cellular Automata Map")
        createCellAutoMapButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-70)
        self.addChild(createCellAutoMapButton)
        

        let createBigBangMapButton = GenericRoundSpriteButtonWithName("bigBangMapButton", text: "Create a Best Fit, left to Right Map")
        createBigBangMapButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-120)
        self.addChild(createBigBangMapButton)
        
        
        let testSceneMapButton = GenericRoundSpriteButtonWithName("testScenePlayground", text: "Test Shit Goes Here")
        testSceneMapButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-170)
        self.addChild(testSceneMapButton)

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
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)

        
        //D-Pad code goes here...
        if ((touchedNode.name) != nil){
            
            switch touchedNode.name! {

                case "cellMapButton":
                    let playScene = PlayScene(size: self.size, dungeonType: "cellMap")
                    self.view?.presentScene(playScene, transition: reveal)

            
                case "cellAutoMapButton":
                    let playScene = PlayScene(size: self.size, dungeonType: "cellAutoMap")
                    self.view?.presentScene(playScene, transition: reveal)

                
                case "bigBangMapButton":
                    let playScene = PlayScene(size: self.size, dungeonType: "bigBangMap")
                    self.view?.presentScene(playScene, transition: reveal)

                
                case "testScenePlayground":
                    let testScene = TestScene(size: self.size)
                    self.view?.presentScene(testScene, transition: reveal)

                
                default:
                    //nothing
                    print("do nothing")

            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
