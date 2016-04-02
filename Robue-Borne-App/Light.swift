//
//  Light.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/1/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit

struct LightCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Hero     : UInt32 = 0b1       // 1
    static let Room     : UInt32 = 0b10      // 2
}