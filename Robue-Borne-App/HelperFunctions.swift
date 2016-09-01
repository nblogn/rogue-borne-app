//
//  HelperFunctions.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 3/20/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation
import SpriteKit




//-------------------------------------------------------------------------------------------//
//
//HANDY FUNCs I'm Probably going to need go here...
//Grabbed these from the SK tutorial here
//http://www.raywenderlich.com/119815/sprite-kit-swift-2-tutorial-for-beginners
//
//-------------------------------------------------------------------------------------------//



/*Note: You may be wondering what the fancy syntax is here. Note that the category on Sprite Kit is just a single 32-bit integer, and acts as a bitmask. This is a fancy way of saying each of the 32-bits in the integer represents a single category (and hence you can have 32 categories max). Here you’re setting the first bit to indicate a monster, the next bit over to represent a projectile, and so on.*/
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1
    static let Projectile: UInt32 = 0b10
}


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

