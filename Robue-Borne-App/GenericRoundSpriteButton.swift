//
//  GenericRoundSpriteButton.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 7/2/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation


//
//  rbGenericRoundButton.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/17/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit


class GenericRoundSpriteButtonWithName: SKSpriteNode {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(_ name: String, text: String) {
        
        
        
        //////////
        //Button text
        let buttonText = SKLabelNode(fontNamed:"Cochin")
        buttonText.text = text
        buttonText.fontSize = 28
        buttonText.fontColor = SKColor.whiteColor()
        buttonText.zPosition = 100
        buttonText.name = name

        var textBounds = buttonText.calculateAccumulatedFrame()
        textBounds.size.height += 20
        textBounds.size.width += 15

        let buttonSize = CGSize(width: textBounds.width, height: textBounds.height)

        
        //Crazy shit to center the text within the button...
        buttonText.position = CGPoint(x: 0, y: -(buttonText.fontSize/2))
        
        let buttonColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)

        
        
        super.init(texture:nil, color: buttonColor, size: buttonSize)

        
        self.zPosition = 101
        
        self.addChild(buttonText)

        userInteractionEnabled = true
        
    }
    
    //This isn't working...
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.color = UIColor(red: 1, green: 0.5, blue: 0.4, alpha: 1)
        
        print("GenericRoundSpriteButtonWithName touched!")
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.color = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        print("GenericRoundSpriteButtonWithName touches ended :(")

    }
    
    
}
