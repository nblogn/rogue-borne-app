//
//  PlayScene.swift
//  Robue-Borne-App
//
//  Created by Joshua Wright on 2/13/16.
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

//From me: I probably need some conversions of array coordinates to CGPoint coordinate...
func convertBoardCoordinatetoCGPoint () -> CGPoint {

    //bogus placeholder code
    let cgpoint = CGPoint(x: 1,y: 2)
    
    return cgpoint
}

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


//In the code above we created a new enum Tile definition and gave it the option to either be assigned as a Ground tile or a Wall tile with respective description and image variables. Note that the image string is the name of the file that we’ll get from the sprite.atlas folder in our project navigator. You don’t need to include the .png file extension.
enum Tile: Int {
    
    case Ground
    case Wall
    
    var description:String {
        switch self {
        case Ground:
            return "Ground"
        case Wall:
            return "Wall"
        }
    }
    
    var image:String {
        switch self {
        case Ground:
            return "ground"
        case Wall:
            return "wall"
            
        }
    } 
}



//-------------------------------------------------------------------------------------------//
//
//The main PlayScene...
//
//-------------------------------------------------------------------------------------------//
class PlayScene: SKScene {
    
    //If you override an initializer on a scene, you must implement the required init(coder:) initializer as well. However this initializer will never be called, so you just add a dummy implementation with a fatalError(_:) for now.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Declaration of your constants. Their values will be assigned in the class initialisation. We’ll be setting up 2 views of the same scene. view2D will be a top down view so we can easily see mapping of coordinates in a simple 2D grid. viewIso will be the isometric view that we would use for our games final rendering.
    let view2D:SKSpriteNode
    let viewIso:SKSpriteNode
    
    //These constants can be declared and set right away, as they are not instances. tiles is a nested array of ids that we will use to generate our tile map. Formatting the array like this allows us to visualise how the map will display. 1 represents a wall and 0 represents ground (walkable area), so this map indicates we are creating a simple, square area enclosed by 4 walls.
    //JOSH: I need to replace this with the dungeon
    let tiles = [
        [1, 1, 1, 1, 1, 1],
        [1 ,0, 0, 0, 0, 1],
        [1 ,0, 0, 0, 0, 1],
        [1 ,0, 0, 0, 0, 1],
        [1 ,0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1]
    ]
    //tileSize is what it seems, the constant width and height of each tile.
    //JOSH: Sounds simple, but what measurement is this? Pixels? Arbitrary unit?
    let tileSize = (width:32, height:32)
    
    //Our class initialisation. Assigning SKSpriteNode instances to our view constants, the standard super.init code (required when subclassing SKScene) and then we centre our scenes anchorPoint (this is just a preference).
    override init(size: CGSize) {
        
        view2D = SKSpriteNode()
        viewIso = SKSpriteNode()
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }
    
    //As the view is loaded we position our 2 sub views so we can easily see and interact with either/or. The deviceScale constant adjusts the scale to fit dynamically to the screen size of whatever device you’re testing on.
    override func didMoveToView(view: SKView) {
        
        let deviceScale = self.size.width/667
        
        view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        
        viewIso.position = CGPoint(x:self.size.width*0.12, y:self.size.height*0.12)
        viewIso.xScale = deviceScale
        viewIso.yScale = deviceScale
        addChild(viewIso)
        
        placeAllTiles2D()
    }
    
    //This function creates and places a sprite in the view2D instance. It’s important to set the anchorPoint to 0,0 (bottom, left). We’ll use this method in the next step, to place our tiles.
    func placeTile2D(image:String, withPosition:CGPoint) {
        
        let tileSprite = SKSpriteNode(imageNamed: image)
        
        tileSprite.position = withPosition
        
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        
        view2D.addChild(tileSprite)
        
    }
    

    func placeAllTiles2D() {
        
        //Loop through all tiles
        for i in 0..<tiles.count {
            
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tileInt = row[j]
                
                //Assign a new Tile enum, setting it’s type via the id value, e.g. because we used an enum for our Tile, 0 = Ground, 1 = Wall
                let tile = Tile(rawValue: tileInt)!
                
                //We then stack each tileSprite in a grid, left to right, then top to bottom. Note: We need to invert the y value because in the SpriteKit coordinate system, y values increase as you move up the screen and decrease as you move down.
                var point = CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height))
                
                placeTile2D(tile.image, withPosition:point)
            }
            
        }
        
    }
    
}










//////
/*OLD, works...
override init(size: CGSize) {

super.init(size: size)

// Sets the background color to white, same as you did for the main scene.
backgroundColor = SKColor.whiteColor()

// Based on the won parameter, sets the message to either “You Won” or “You Lose”.
let message = "Board goes here."
let label = SKLabelNode(fontNamed: "Chalkduster")
label.text = message
label.fontSize = 40
label.fontColor = SKColor.blackColor()
label.position = CGPoint(x: size.width/2, y: size.height/2)
addChild(label)


}

//If you override an initializer on a scene, you must implement the required init(coder:) initializer as well. However this initializer will never be called, so you just add a dummy implementation with a fatalError(_:) for now.
required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    
    for touch in touches {
        let location = touch.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = location
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
}
*/

