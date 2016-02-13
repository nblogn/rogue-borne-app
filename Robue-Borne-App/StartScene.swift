//
//  GameScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/10/16.
//  Copyright (c) 2016 nblogn.com. All rights reserved.
//

import SpriteKit

class GameStartScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "RogueBorne"
        myLabel.fontSize = 45
        myLabel.fontColor = SKColor.redColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        let myClickToPlayLabel = SKLabelNode(fontNamed: "Cochin")
        myClickToPlayLabel.text = "Click to Play"
        myClickToPlayLabel.fontSize = 20
        myClickToPlayLabel.fontColor = SKColor.blackColor()
        myClickToPlayLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-40)
        
        self.addChild(myClickToPlayLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let playScene = PlayScene(size: self.size)
        self.view?.presentScene(playScene, transition: reveal)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
