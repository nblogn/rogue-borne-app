//
//  dPad.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/6/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

//TODO refactor to "DPad", capital D for class.
class dPad: SKNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {

        super.init()

        let RB_Cntrl_Up = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_Up"))
        let RB_Cntrl_Down = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_Down"))
        let RB_Cntrl_Left = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_Left"))
        let RB_Cntrl_Right = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_Right"))
        let RB_Cntrl_Middle = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_Middle"))
        //let RB_Cntrl_UpLeft = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_UpLeft"))
        //let RB_Cntrl_UpRight = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_UpRight"))
        //let RB_Cntrl_DownLeft = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_DownLeft"))
        //let RB_Cntrl_DownRight = SKSpriteNode(texture: SKTexture(imageNamed: "RB_Cntrl_DownRight"))
        
        RB_Cntrl_Up.position = CGPoint(x:200, y: 300)
        RB_Cntrl_Down.position = CGPoint(x:200, y: 100)
        RB_Cntrl_Left.position = CGPoint(x:100, y: 200)
        RB_Cntrl_Right.position = CGPoint(x:300, y: 200)
        RB_Cntrl_Middle.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_UpLeft.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_UpRight.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_DownLeft.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_DownRight.position = CGPoint(x:200, y: 200)

        
        RB_Cntrl_Up.name = "RB_Cntrl_Up"
        RB_Cntrl_Down.name = "RB_Cntrl_Down"
        RB_Cntrl_Left.name = "RB_Cntrl_Left"
        RB_Cntrl_Right.name = "RB_Cntrl_Right"
        RB_Cntrl_Middle.name = "RB_Cntrl_Middle"
        //RB_Cntrl_UpLeft.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_UpRight.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_DownLeft.position = CGPoint(x:200, y: 200)
        //RB_Cntrl_DownRight.position = CGPoint(x:200, y: 200)
        
        
        self.addChild(RB_Cntrl_Up)
        self.addChild(RB_Cntrl_Down)
        self.addChild(RB_Cntrl_Left)
        self.addChild(RB_Cntrl_Right)
        self.addChild(RB_Cntrl_Middle)
        //self.addChild(RB_Cntrl_UpLeft)
        //self.addChild(RB_Cntrl_UpRight)
        //self.addChild(RB_Cntrl_DownLeft)
        //self.addChild(RB_Cntrl_DownRight)
        
        self.isUserInteractionEnabled = true
        self.name = "dPad"
        
        
        
    }
    
}
