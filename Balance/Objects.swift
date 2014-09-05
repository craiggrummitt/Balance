//
//  Objects.swift
//  Balance
//
//  Created by CraigGrummitt on 27/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//


import UIKit
import SpriteKit

/*enum ObjectsConsts:Int {
    case OBJECT_MAX = 7
    case BRIEFCASE_MAX = 7
    case BLOCK_MAX = 10
}*/

class Objects {
    var objectFrames:Array<SKTexture>=[]
    let OBJECT_MAX = 7
    let BRIEFCASE_MAX = 7
    let BLOCK_MAX = 10
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(imagesAtlas:SKTextureAtlas) {
        let deviceType=ConfigurationManager.sharedInstance.getDeviceType().toRaw()
        for i in 1...OBJECT_MAX {
            objectFrames.append(imagesAtlas.textureNamed("briefcase\(i)"+deviceType+".png"))
        }
        for i in 1...OBJECT_MAX {
            objectFrames.append(imagesAtlas.textureNamed("block\(i)"+deviceType+".png"))
        }
    }
    func getObject(objectNo:Int)->SKSpriteNode {
        var object=SKSpriteNode(texture: objectFrames[objectNo])
        return(object)
    }
    func generatePhysics(var object:SKSpriteNode,objectNo:Int) {
        object.physicsBody = getPhysicsBody(object, objectNo: objectNo)
        object.physicsBody.categoryBitMask = GameScene.ColliderType.ObjectCategory.toRaw()  //what's this?
        object.physicsBody.contactTestBitMask = GameScene.ColliderType.ManCategory.toRaw() | GameScene.ColliderType.ObjectCategory.toRaw() //what to notify contact of
        object.physicsBody.collisionBitMask = GameScene.ColliderType.ManCategory.toRaw() | GameScene.ColliderType.ObjectCategory.toRaw() | GameScene.ColliderType.BorderCategory.toRaw() //what to bounce off
        object.physicsBody.friction=1.0
        object.physicsBody.linearDamping=1.0
        object.physicsBody.mass=1
        object.physicsBody.dynamic = true
    }
    func getPhysicsBody(sprite:SKSpriteNode, objectNo:Int)->SKPhysicsBody {
        switch objectNo {
        case 0,1:
            return(SKPhysicsBody(rectangleOfSize: CGSize(width: 85, height: 53), center: CGPoint(x: 0, y: 0)))
        case 2:
            return(SKPhysicsBody(rectangleOfSize: CGSize(width: 65, height: 40), center: CGPoint(x: 0, y: 0)))
        case 3:
            return(SKPhysicsBody(rectangleOfSize: CGSize(width: 60, height: 37), center: CGPoint(x: 0, y: 0)))
        case 4:
            return(SKPhysicsBody(rectangleOfSize: CGSize(width: 68, height: 44), center: CGPoint(x: 0, y: 0)))
        case 5:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 127 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 135 - offsetX, 7 - offsetY);
            CGPathAddLineToPoint(path, nil, 134 - offsetX, 19 - offsetY);
            CGPathAddLineToPoint(path, nil, 127 - offsetX, 25 - offsetY);
            CGPathAddLineToPoint(path, nil, 70 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 59 - offsetX, 44 - offsetY);
            CGPathAddLineToPoint(path, nil, 46 - offsetX, 44 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 54 - offsetY);
            CGPathAddLineToPoint(path, nil, 15 - offsetX, 52 - offsetY);
            CGPathAddLineToPoint(path, nil, 3 - offsetX, 44 - offsetY);
            CGPathAddLineToPoint(path, nil, 0 - offsetX, 26 - offsetY);
            CGPathAddLineToPoint(path, nil, 3 - offsetX, 9 - offsetY);
            CGPathAddLineToPoint(path, nil, 12 - offsetX, 1 - offsetY);
            CGPathAddLineToPoint(path, nil, 23 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 32 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 40 - offsetX, 4 - offsetY);
            CGPathAddLineToPoint(path, nil, 48 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 54 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 60 - offsetX, 2 - offsetY);
            CGPathAddLineToPoint(path, nil, 68 - offsetX, 8 - offsetY);
            CGPathAddLineToPoint(path, nil, 128 - offsetX, 0 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 6:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 76 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 81 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 81 - offsetX, 9 - offsetY);
            CGPathAddLineToPoint(path, nil, 77 - offsetX, 14 - offsetY);
            CGPathAddLineToPoint(path, nil, 41 - offsetX, 18 - offsetY);
            CGPathAddLineToPoint(path, nil, 37 - offsetX, 25 - offsetY);
            CGPathAddLineToPoint(path, nil, 27 - offsetX, 26 - offsetY);
            CGPathAddLineToPoint(path, nil, 17 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 28 - offsetY);
            CGPathAddLineToPoint(path, nil, 0 - offsetX, 17 - offsetY);
            CGPathAddLineToPoint(path, nil, 3 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 9 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 19 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 25 - offsetX, 2 - offsetY);
            CGPathAddLineToPoint(path, nil, 30 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 33 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 42 - offsetX, 5 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
    //BLOCKS
        case 7:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 86 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
            
        case 8:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 58 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 9:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 86 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 10:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 11:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 58 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 12:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 58 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 13:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 86 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 86 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 14:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 58 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 58 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 60 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 15:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 29 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 29 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 88 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        case 16:
            var offsetX = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY = sprite.frame.size.height * sprite.anchorPoint.y
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 114 - offsetX, 3 - offsetY);
            CGPathAddLineToPoint(path, nil, 114 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 32 - offsetY);
            CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY);
            
            CGPathCloseSubpath(path)
            
            return(SKPhysicsBody(polygonFromPath: path))
        default:
            return(SKPhysicsBody(rectangleOfSize: CGSize(width: sprite.size.width, height: sprite.size.height)))
        }
        
            

    }
}