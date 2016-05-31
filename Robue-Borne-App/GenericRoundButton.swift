//
//  rbGenericRoundButton.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/17/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


class GenericRoundButtonWithName: SKNode {
    
    
    let button2 = SKSpriteNode()
    let button = SKShapeNode()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(_ name: String, text: String) {
        
        super.init()
        
        //////////
        //Button
        let buttonText = SKLabelNode(fontNamed:"Cochin")
        buttonText.text = text
        buttonText.fontSize = 28
        buttonText.fontColor = SKColor.whiteColor()
        buttonText.zPosition = 101
        buttonText.name = name
        
        var textBounds = buttonText.calculateAccumulatedFrame()
        textBounds.size.height += 20
        textBounds.size.width += 15
        
        //button2 = CGSize(UIBezierPath(roundedRect: textBounds, cornerRadius: 8).CGPath)
        
        button.path = UIBezierPath(roundedRect: textBounds, cornerRadius: 8).CGPath
        button.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        button.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        button.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        button.lineWidth = 2
        button.glowWidth = 3
        button.zPosition = 100
        button.name = name
        button.position = CGPoint(x: 0, y:0)
        
        self.addChild(buttonText)

        //Crazy shit to center the text within the button...
        buttonText.position = CGPoint(x:(CGRectGetMidX(button.frame)), y:(CGRectGetMidY(button.frame) - (buttonText.fontSize/2) + 1))
        
        self.addChild(button)

    }
    
    //This isn't working...
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        button.fillColor = UIColor(red: 1, green: 0.5, blue: 0.4, alpha: 1)

        print("GenericRoundButtonWithName touched!")
        
    }

    

}
