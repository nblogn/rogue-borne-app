//
//  GenericText.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 5/4/16.
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


class GenericText: SKLabelNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(name: String, text: String) {
        
        super.init()
        
        let genericText = SKLabelNode(fontNamed:"Cochin")
        genericText.text = text
        genericText.fontSize = 20
        genericText.fontColor = SKColor.whiteColor()
        genericText.zPosition = 101
        genericText.name = name
        
        self.addChild(genericText)
        
        
    }
    
    
}
