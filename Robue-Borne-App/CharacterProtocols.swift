//
//  AbilityProtocols.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 4/11/16.
//  Copyright © 2016 nblogn.com. All rights reserved.
//

//Some ideas for how to organize abilities...

import Foundation



protocol BasicCharacterAbilities {
    var hitPoints: Int {get set}
    var location: DungeonLocation {get set}

    func getStats() -> String
    func getCurrentLocation() -> DungeonLocation
}

//extension basicCharacterAbilities where Self: BasicCharacterAbilities




protocol magic {
    //?
}




protocol teleportation {
    //?
}




/*
struct mage: basicCharacterAbilities, magic {
    

}


 
struct warrior: basicCharacterAbilities {

    var hitPoints: Int = 20
    
}
 
*/



