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
        
        
        let myTitle = SKLabelNode(fontNamed:"Chalkduster")
        myTitle.text = "Mimeophobia"
        myTitle.fontSize = 45
        myTitle.fontColor = SKColor.redColor()
        myTitle.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+200)
        self.addChild(myTitle)
        
        let mySubTitle = SKLabelNode(fontNamed: "cochin")
        mySubTitle.text = "...Or How I Learned To Love My Doppleganger"
        mySubTitle.fontSize = 20
        mySubTitle.fontColor = SKColor.redColor()
        mySubTitle.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+150)
        self.addChild(mySubTitle)

        
        let createCellMapButton = GenericRoundButtonWithName("cellMapButton", text: "Create a Cell Map")
        createCellMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-40)
        self.addChild(createCellMapButton)
        
        
        let createCellAutoMapButton = GenericRoundButtonWithName("cellAutoMapButton", text: "Create a Cellular Automata Map")
        createCellAutoMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-110)
        self.addChild(createCellAutoMapButton)
        

        let createBigBangMapButton = GenericRoundButtonWithName("bigBangMapButton", text: "Create a Best Fit, left to Right Map")
        createBigBangMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-180)
        self.addChild(createBigBangMapButton)
        
        
        let testSceneMapButton = GenericRoundButtonWithName("testScenePlayground", text: "Test Shit Goes Here")
        testSceneMapButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-250)
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
