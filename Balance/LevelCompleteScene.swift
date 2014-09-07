//
//  LevelCompleteScene.swift
//  Balance
//
//  Created by CraigGrummitt on 4/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

enum LevelCompleteEvents:String {
    case EventMenu="LevelCompleteMenu"
    case EventNext="LevelCompleteNext"
    case EventReplay="LevelCompleteReplay"
}
class LevelCompleteScene: SKScene, SKButtonDelegate {
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    var success:Bool = false
    var nextAvailable:Bool = false
    var titleLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    var nextReplayButton:SKButton!
    var menuButton:SKButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(success:Bool, nextAvailable:Bool, size: CGSize) {
        self.success=success
        self.nextAvailable=nextAvailable
        super.init(size:size)
    }
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        if (!success || nextAvailable) {
            nextReplayButton = SKButton(offTexture: cm.getImageTexture("button"), downTexture: cm.getImageTexture("buttonDown"), text:success ? "NEXT" : "REPLAY")
            nextReplayButton.delegate = self
            nextReplayButton.position = CGPoint(x:CGRectGetMidX(self.view!.bounds)-110, y:CGRectGetMidY(self.view!.bounds))
            self.addChild(nextReplayButton)
            nextReplayButton.hidden=true
        }
        
        menuButton = SKButton(offTexture: cm.getImageTexture("button"), downTexture: cm.getImageTexture("buttonDown"), text:"MENU")
        menuButton.delegate = self
        menuButton.position = CGPoint(x:CGRectGetMidX(self.view!.bounds)+110, y:CGRectGetMidY(self.view!.bounds))
        self.addChild(self.menuButton)
        menuButton.hidden=true
        
        if (success) {
            titleLabel.text = "LEVEL COMPLETE!"
            self.runAction(SKAction.playSoundFileNamed("011436082-level-complete-2.mp3", waitForCompletion: false))
        } else {
            titleLabel.text = "BAD LUCK!"
            self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        }
        titleLabel.fontSize = 65
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view!.bounds), y:CGRectGetMidY(self.view!.bounds)-titleLabel.frame.height/2)
        self.addChild(titleLabel)
        self.titleLabel.runAction(SKEase.scaleFromWithNode(titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
            self.menuButton.hidden=false
            self.titleLabel.runAction(SKEase.moveToWithNode(self.titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, toVector: CGVector(self.titleLabel.position.x,self.titleLabel.position.y+self.titleLabel.frame.height/2+self.menuButton.frame.height/2+20)))
            self.menuButton.runAction(SKEase.scaleFromWithNode(self.menuButton, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0))
            if (self.nextAvailable) {
                self.nextReplayButton.hidden=false
                self.nextReplayButton.runAction(SKEase.scaleFromWithNode(self.nextReplayButton, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0))
            }
        }
    }
    func buttonUp(button: SKButton) {
        switch(button) {
        case nextReplayButton:
            if (success) {
                NSNotificationCenter.defaultCenter().postNotificationName(LevelCompleteEvents.EventNext.toRaw(), object:self)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(LevelCompleteEvents.EventReplay.toRaw(), object:self)
            }
        case menuButton:
            NSNotificationCenter.defaultCenter().postNotificationName(LevelCompleteEvents.EventMenu.toRaw(), object:self)
        default:
            println("WHAT ARE WE DOING HERE?")
        }
    }
}
