//
//  TitleScene.swift
//  Balance
//
//  Created by CraigGrummitt on 26/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

enum TitleEvents:String {
    case EventComplete="TitleEventComplete"
}

class TitleScene: SKScene,SKButtonDelegate {
    var crashLabel:SKSpriteNode!
    var bamLabel:SKSpriteNode!
    
    let subtitleLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    var readyForClick = false
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    
    override init(size: CGSize) {
        super.init(size:size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        println("\(self.view!.bounds.width),\(self.view!.bounds.height)")
        self.backgroundColor = SKColor.whiteColor()
        createLabels()
        
    }
    func createLabels() {
        self.crashLabel = SKSpriteNode(texture: cm.getImageTexture("crash"))
        self.crashLabel.position = CGPoint(x:CGRectGetMidX(self.view!.bounds)-110, y:CGRectGetMidY(self.view!.bounds))
        
        self.bamLabel = SKSpriteNode(texture: cm.getImageTexture("bam"))
        self.bamLabel.position = CGPoint(x:CGRectGetMidX(self.view!.bounds)+110, y:CGRectGetMidY(self.view!.bounds)+10)
        
       /* titleLabel.text = "CRASH BOOM!"
        titleLabel.fontSize = 45
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view!.bounds), y:CGRectGetMidY(self.view!.bounds))*/
        
        subtitleLabel.text = "Touch to play"
        self.subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view!.bounds), y:self.crashLabel.position.y-self.crashLabel.size.height+50)
        subtitleLabel.fontSize = 14
        subtitleLabel.fontColor = UIColor.blackColor()
        
        self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        self.addChild(crashLabel)
        self.crashLabel.runAction(SKEase.scaleFromWithNode(crashLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0))
        self.runAction(SKAction.waitForDuration(0.5)) {
            self.addChild(self.bamLabel)
            self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
            self.bamLabel.runAction(SKEase.scaleFromWithNode(self.bamLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
                self.addChild(self.subtitleLabel)
                self.runAction(SKAction.playSoundFileNamed("woosh_3.mp3", waitForCompletion: false))
                self.subtitleLabel.runAction(self.flyOn(self.subtitleLabel))
                self.readyForClick=true
            }
        }
    }
    func flyOn(node:SKNode)->SKAction {
        var action=SKEase.moveFromWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, fromVector: CGVectorMake(view!.bounds.width+node.frame.width/2, node.position.y))
        return action
    }
    func flyOff(node:SKNode)->SKAction {
        var action=SKEase.moveToWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeIn, time: 1, toVector: CGVectorMake(-node.frame.width/2, node.position.y))
        return action
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var foundTouch = false
        for touch: AnyObject in touches {
            foundTouch=true
            let location = touch.locationInNode(self)
        }
        if readyForClick && foundTouch {
            self.crashLabel.runAction(flyOff(self.crashLabel))
            self.bamLabel.runAction(flyOff(self.bamLabel))
            self.subtitleLabel.runAction(self.flyOff(self.subtitleLabel)) {
                    NSNotificationCenter.defaultCenter().postNotificationName(TitleEvents.EventComplete.toRaw(), object:self)
            }
        }
    }
    }
