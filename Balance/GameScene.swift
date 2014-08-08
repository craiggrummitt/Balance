//
//  GameScene.swift
//  Balance
//
//  Created by CraigGrummitt on 4/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    enum DeviceType:String {
        case IPAD = "~ipad"
        case IPAD2x = "@2x~ipad"
    }
    enum GameStatus:Int {
        case STARTING = 1
        case READY_FOR_CLICK = 2
        case PLAYING_GAME = 3
    }

    let TORTURE_MAX = 3
    let BRIEFCASE_MAX = 3
    let titleLabel = SKLabelNode(fontNamed:"Avenir-Light")
    let subtitleLabel = SKLabelNode(fontNamed:"Avenir-Light")
    var torture:SKSpriteNode!

    var tortureWalkingFrames:Array<SKTexture>=[]
    var briefcaseFrames:Array<SKTexture>=[]
    var briefcases:Array<SKSpriteNode>=[]
    var arrowRight:SKSpriteNode!
    var arrowLeft:SKSpriteNode!
    var deviceType:DeviceType!//attempted to place this in lazy var without success
    
    var gameStatus:Int = GameStatus.STARTING.toRaw()
    
    func getDeviceType()->DeviceType {
        if self.frame.width==1024.0 {
            return .IPAD
        } else if self.frame.width==2048.0 {
            return .IPAD2x
        }
        return .IPAD
    }
    
    override func didMoveToView(view: SKView) {
        deviceType = self.getDeviceType()
        self.backgroundColor = SKColor.whiteColor()
        
        titleLabel.text = "Balance!"
        titleLabel.fontSize = 65
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        subtitleLabel.text = "Touch to continue"
        subtitleLabel.fontSize = 14
        subtitleLabel.fontColor = UIColor.blackColor()
        subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:titleLabel.position.y-subtitleLabel.frame.height-10)
        

        
        //set up images
        var imagesAtlas = SKTextureAtlas(named: "images")
        //get torture
        for i in 1...TORTURE_MAX {
            tortureWalkingFrames.append(imagesAtlas.textureNamed("torture\(i)"+getDeviceType().toRaw()+".png"))
        }
        torture = SKSpriteNode(texture: tortureWalkingFrames[0])
        
        
        
        //get briefcases
        for i in 1...BRIEFCASE_MAX {
            briefcaseFrames.append(imagesAtlas.textureNamed("briefcase\(i)"))
        }
        //get arrows
        arrowRight = SKSpriteNode(texture: imagesAtlas.textureNamed("arrowRight"+getDeviceType().toRaw()+".png"))
        arrowRight.position = CGPoint(x: self.frame.width-arrowRight.size.width-10, y: CGRectGetMidY(self.frame))
        //arrowLeft = SKSpriteNode(texture: imagesAtlas.textureNamed("arrorLeft"))
        //arrowLeft.position = CGPoint(x: 10, y: CGRectGetMidY(self.frame))
        self.addChild(arrowRight)
        //self.addChild(arrowLeft)

        //torture.position = CGPointMake(CGRectGetMidX(frame),10+torture.size.height/2)
        torture.position = CGPointMake(self.frame.width,10+torture.size.height/2)
        

        self.addChild(titleLabel)
        flyOn(titleLabel)
        
        self.addChild(torture)
        self.walkingTorture()
        self.animateTortureToCentreOfScreen()
    }
    func setReadyForClick() {
        self.stopWalkingTorture()
        self.addChild(subtitleLabel)
        flyOn(subtitleLabel)
        gameStatus=GameStatus.READY_FOR_CLICK.toRaw()
        
    }
    func animateTortureToCentreOfScreen() {
        torture.runAction(SKAction.moveTo(CGPointMake(CGRectGetMidX(self.frame),10+torture.size.height/2), duration: 4)) {
            self.setReadyForClick()
        }
    }
    func stopWalkingTorture() {
        torture.removeActionForKey("walkingInPlaceTorture")
    }
    func walkingTorture() {
        torture.runAction(
            SKAction.repeatActionForever(
            
            SKAction.animateWithTextures(self.tortureWalkingFrames, timePerFrame: 0.1, resize: true, restore: true)
            ),
            withKey: "walkingInPlaceTorture"
        )
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameStatus==GameStatus.STARTING.toRaw() {return}
        
        var foundTouch = false
        for touch: AnyObject in touches {
            foundTouch=true
            let location = touch.locationInNode(self)
        }
        if foundTouch && gameStatus==GameStatus.READY_FOR_CLICK.toRaw() {
            gameStatus=GameStatus.PLAYING_GAME.toRaw()
            flyOff(titleLabel)
            flyOff(subtitleLabel)
        }
    }
    func flyOn(node:SKNode) {
        var action=SKEase.moveFromWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, fromVector: CGVectorMake(frame.width+node.frame.width/2, node.position.y))
        
       // (node, easeFunction:0, mode:0, time: 1, fromVector: CGVectorMake(frame.width+node.frame.width/2, node.position.y))
        //node.position.x=frame.width+node.frame.width/2
        //var action=SKAction.moveTo(CGPointMake(CGRectGetMidX(frame), node.position.y),duration: 1)
        node.runAction(action)
    }
    func flyOff(node:SKNode) {
        var action=SKEase.moveToWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeIn, time: 1.5, toVector: CGVectorMake(frame.width+node.frame.width/2, node.position.y))
        
        //node.runAction(SKEase.MoveFromWithNode(node, easeFunction: 0, mode: 0, time: 1, fromVector: CGVectorMake(-node.frame.width/2, node.position.y)))
        
        //node.position.x=CGRectGetMidX(frame)
        //var action=SKAction.moveTo(CGPointMake(frame.width+node.frame.width/2, node.position.y),duration: 1)
        node.runAction(action)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
