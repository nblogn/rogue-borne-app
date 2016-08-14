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
    
    
    
    
    enum ButtonState {
        case normal, highlighted, disabled
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(_ name: String, text: String) {
        
        //////////
        //Create button text
        let buttonText = SKLabelNode(fontNamed:"Cochin")
        buttonText.text = text
        buttonText.fontSize = 28
        buttonText.fontColor = SKColor.white
        buttonText.zPosition = 100
        buttonText.name = name
        
        var textBounds = buttonText.calculateAccumulatedFrame()
        textBounds.size.height += 20
        textBounds.size.width += 15
        
        let buttonSize = CGSize(width: textBounds.width, height: textBounds.height)
        
        //Init super class
        let buttonColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        super.init(texture:nil, color: buttonColor, size: buttonSize)

        //Set self properties
        self.name = name
        self.zPosition = 101
        self.isUserInteractionEnabled = true
        
        //Crazy shit to center the text within the button...
        buttonText.position = CGPoint(x: 0, y: -(buttonText.fontSize/2))
        self.addChild(buttonText)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.color = UIColor(red: 1, green: 0.5, blue: 0.4, alpha: 1)
        
        print("GenericRoundSpriteButtonWithName touched! :)")
        
    }
    
    
    //This is working, but oddly. There seems to be some confusion about the diff between ended vs. cancelled. Google it if curious, but otherwise, use both (or, I think you could just call ended from cancelled).
    //I've noticed that in the emulator, if I long-press I will get touchesEnded, if I quick-press I get touchesCancelled. Note, this works the same with the SgButton class I was testing (and is one of the reasons I was thinking of NOT using that class. Alas.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.color = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        print("GenericRoundSpriteButtonWithName touches ended :(")

    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.color = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 0.7)
        print("GenericRoundSpriteButtonWithName touches cancelled, whoo :|")
    
    }
    
    
}
