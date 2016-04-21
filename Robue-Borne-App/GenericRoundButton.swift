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
        buttonText.position = CGPoint(x:80, y:20)
        buttonText.zPosition = 100
        
        var textBounds = buttonText.calculateAccumulatedFrame()
        textBounds.size.height += 15
        textBounds.size.width += 10
        
        let button = SKShapeNode()
        button.path = UIBezierPath(roundedRect: textBounds, cornerRadius: 8).CGPath
        button.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        button.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        button.strokeColor = UIColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 0.7)
        button.lineWidth = 2
        button.glowWidth = 3
        button.zPosition = 99
        button.name = name
        button.position = CGPoint(x: 0, y:0)

        
        button.addChild(buttonText)
        
        buttonText.position = CGPoint(x:80, y:20)
        
        addChild(button)

    }
    

}
