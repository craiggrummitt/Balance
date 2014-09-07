//
//  Man.swift
//  Balance
//
//  Created by CraigGrummitt on 15/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import UIKit
import SpriteKit

class Man: SKNode {
    let BOBBING_KEY="bobbing in place"
    let WALKING_KEY="walking"
    let RUNNING_KEY="running"
    let MAN_FRAMES_MAX = 3
    let MIN_VELOCITY_WALK = CGFloat(3.0)
    let MIN_VELOCITY_RUN = CGFloat(50.0)
    var manBobbingFrames:Array<SKTexture>=[]
    var manWalkingFrames:Array<SKTexture>=[]
    var man:SKSpriteNode!
    var manWalking = false
    var manBobbingTextureNames=["01","02","03","04","05","04","03","02","01"]
    var manWalkingTextureNames=["10","11","12","13","14","15","16","17","18","19"]
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
     
    init(imagesAtlas:SKTextureAtlas) {
        super.init()
        for i in 0..<manBobbingTextureNames.count {
//            println("man\(manBobbingTextureNames[i])"+ConfigurationManager.sharedInstance.getDeviceType().toRaw()+".png")
            manBobbingFrames.append(imagesAtlas.textureNamed("man\(manBobbingTextureNames[i])"+ConfigurationManager.sharedInstance.getDeviceType().toRaw()+".png"))
        }
        for i in 0..<manWalkingTextureNames.count {
            manWalkingFrames.append(imagesAtlas.textureNamed("man\(manWalkingTextureNames[i])"+ConfigurationManager.sharedInstance.getDeviceType().toRaw()+".png"))
        }
        man = SKSpriteNode(texture: manWalkingFrames[0])
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: frame.size, center: CGPointMake(0,0))//CGSize(width: 120,height: 60)
        self.physicsBody!.dynamic = false
        self.physicsBody!.categoryBitMask = GameScene.ColliderType.ManCategory.toRaw()  //what's this?
        self.physicsBody!.contactTestBitMask = 0 //what to notify contact of
        self.physicsBody!.collisionBitMask = GameScene.ColliderType.BorderCategory.toRaw()    //what to bounce off
        self.physicsBody!.friction=1.0
        self.physicsBody!.linearDamping=1.0
        self.physicsBody!.mass=5
        self.addChild(man)

    }
    override var frame:CGRect {
        get {
            return man.frame
        }
    
    }
    func stopWalking() {
        if ((man.actionForKey(BOBBING_KEY)) != nil) { return }
        man.removeAllActions()
        man.runAction(
            SKAction.repeatActionForever(
                SKAction.animateWithTextures(self.manBobbingFrames, timePerFrame: 0.1, resize: true, restore: false)
            ),
            withKey: BOBBING_KEY
        )
    }
    func startWalking() {
        if ((man.actionForKey(WALKING_KEY)) != nil) { return }
        man.removeAllActions()
        man.runAction(
            SKAction.repeatActionForever(
                SKAction.animateWithTextures(self.manWalkingFrames, timePerFrame: 0.1, resize: true, restore: false)
            ),
            withKey: WALKING_KEY
        )
    }
    func startRunning() {
        if ((man.actionForKey(RUNNING_KEY)) != nil) { return }
        man.removeAllActions()
        man.runAction(
            SKAction.repeatActionForever(
                SKAction.animateWithTextures(self.manWalkingFrames, timePerFrame: 0.05, resize: true, restore: false)
            ),
            withKey: RUNNING_KEY
        )
    }
    func update() {
        if (self.physicsBody!.velocity.dx > -MIN_VELOCITY_WALK && self.physicsBody!.velocity.dx < MIN_VELOCITY_WALK) {
            stopWalking()
        } else if (self.physicsBody!.velocity.dx > -MIN_VELOCITY_RUN && self.physicsBody!.velocity.dx < MIN_VELOCITY_RUN) {
            startWalking()
        } else {
            startRunning()
        }
    }

}
