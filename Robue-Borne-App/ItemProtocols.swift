//
//  ItemProtocols.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/11/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

import Foundation


protocol basicItemAttributes {
    
}

protocol cursed {
    
}


//THIS!!!
// https://appventure.me/2015/10/17/advanced-practical-enum-examples/
// Finally, all user-wearable items in an RPG could be mapped with one
// enum, that encodes for each item the additional armor and weight
// Now, adding a new material like 'Diamond' is just one line of code and we'll have the option to add several new Diamond-Crafted wearables.
enum Wearable {
    enum Weight: Int {
        case Light = 1
        case Mid = 4
        case Heavy = 10
    }
    enum Armor: Int {
        case Light = 2
        case Strong = 8
        case Heavy = 20
    }
    case Helmet(weight: Weight, armor: Armor)
    case Breastplate(weight: Weight, armor: Armor)
    case Shield(weight: Weight, armor: Armor)
}
let woodenHelmet = Wearable.Helmet(weight: .Light, armor: .Light)


//
enum Wearable2 {
    enum Weight: Int {
        case Light = 1
    }
    enum Armor: Int {
        case Light = 2
    }
    case Helmet(weight: Weight, armor: Armor)
    func attributes() -> (weight: Int, armor: Int) {
        switch self {
        case .Helmet(let w, let a): return (weight: w.rawValue * 2, armor: a.rawValue * 4)
        }
    }
}
// let woodenHelmetProps = Wearable2.Helmet(weight: .Light, armor: .Light).attributes()
// print (woodenHelmetProps)
// prints "(2, 8)"
