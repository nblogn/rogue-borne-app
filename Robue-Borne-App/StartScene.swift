//
//  GameScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright (c) 2016 nblogn.com. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor(red: 0.13, green: 0.1, blue: 0.15, alpha: 0.9)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "RogueBorne"
        myLabel.fontSize = 45
        myLabel.fontColor = SKColor.redColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100)
        
        self.addChild(myLabel)
        
        
        let createCellMapButton = SKLabelNode(fontNamed: "Cochin")
        createCellMapButton.text = "Create a Cell map"
        createCellMapButton.name = "cellMapButton"
        createCellMapButton.fontSize = 30
        createCellMapButton.fontColor = SKColor.whiteColor()
        createCellMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-50)
        
        self.addChild(createCellMapButton)
        
        
        let createCellAutoMapButton = SKLabelNode(fontNamed: "Cochin")
        createCellAutoMapButton.text = "Create a Cellular Automata Map"
        createCellAutoMapButton.name = "cellAutoMapButton"
        createCellAutoMapButton.fontSize = 30
        createCellAutoMapButton.fontColor = SKColor.whiteColor()
        createCellAutoMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-100)

        self.addChild(createCellAutoMapButton)
        
        
        let createBigBangMapButton = SKLabelNode(fontNamed: "Cochin")
        createBigBangMapButton.text = "Create a best fit, Left To Right map"
        createBigBangMapButton.name = "bigBangMapButton"
        createBigBangMapButton.fontSize = 30
        createBigBangMapButton.fontColor = SKColor.whiteColor()
        createBigBangMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-150)
        
        self.addChild(createBigBangMapButton)
        
        
        let testSceneMapButton = SKLabelNode(fontNamed: "Cochin")
        testSceneMapButton.text = "Test Shit Goes Here"
        testSceneMapButton.name = "testScenePlayground"
        testSceneMapButton.fontSize = 30
        testSceneMapButton.fontColor = SKColor.whiteColor()
        testSceneMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-200)
        
        self.addChild(testSceneMapButton)

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)

        let touch = touches 
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If touchToCreateCellMap button is touched, start transition to second scene
        if (node.name == "cellMapButton") {
            let playScene = PlayScene(size: self.size, dungeonType: "cellMap")
            self.view?.presentScene(playScene, transition: reveal)
        }
        
        if (node.name == "cellAutoMapButton") {
            let playScene = PlayScene(size: self.size, dungeonType: "cellAutoMap")
            self.view?.presentScene(playScene, transition: reveal)
        }
        
        if (node.name == "bigBangMapButton") {
            let playScene = PlayScene(size: self.size, dungeonType: "bigBangMap")
            self.view?.presentScene(playScene, transition: reveal)
        }
        
        if (node.name == "testScenePlayground") {
            let testScene = TestScene(size: self.size)
            self.view?.presentScene(testScene, transition: reveal)

        }
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
