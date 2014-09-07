//
//  SublevelScene.swift
//  Balance
//
//  Created by CraigGrummitt on 2/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

enum SublevelEvents:String {
    case EventComplete="SublevelEventComplete"
    case EventBack="SublevelEventBack"
}
class SublevelScene: SKScene,SKButtonDelegate {
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    var level:LevelVO
    var buttons:Array<SKButton>=[]
    var backButton:SKButton!
    var sublevelNo:Int!
    var backDown:Bool=false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(level:LevelVO, size: CGSize) {
        self.level=level
        super.init(size:size)
    }
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        for (var i=0;i<level.subLevels.count;i++) {
            var sublevel = level.subLevels[i]
            var textureName:String!

            switch sublevel.playStatus {
            case .Locked:
                textureName = "subversionLocked"
            case .NoSuccess:
                textureName = "subversion"
            case .Success:
                textureName = "subversionTick"
            }
            var buttonNode:SKButton// = SKSpriteNode(texture: cm.getImageTexture(textureName))
            var buttonName:String=""
            
            if (sublevel.playStatus != .Locked) {
                buttonName = "\(i+1)"
            }
            buttonNode = SKButton(offTexture:  cm.getImageTexture(textureName), downTexture: cm.getImageTexture(textureName),text:buttonName,labelPos:CGPoint(x:-10,y:-10))
            buttonNode.delegate = self
            
            var column:CGFloat = CGFloat(i%5)
            var row:Int = i/5
            
            buttonNode.position = CGPoint(x: 150.0+(column*125.0), y: self.view!.bounds.height-200.0-CGFloat(row)*125.0)
            self.addChild(buttonNode)
            buttons.append(buttonNode)

        }
        backButton = SKButton(offTexture: cm.getImageTexture("back"), downTexture: cm.getImageTexture("backDown"))
        backButton.position=CGPoint(x: 100,y: 100)
        backButton.delegate = self
        self.addChild(backButton)
    }
    func buttonUp(button: SKButton) {
        if (button==backButton) {
            NSNotificationCenter.defaultCenter().postNotificationName(SublevelEvents.EventBack.toRaw(), object:self)
        } else {
            for buttonNo in 0..<buttons.count {
                let sublevelButton = buttons[buttonNo]
                if (button==sublevelButton) {
                    self.sublevelNo = buttonNo
                    if (level.subLevels[buttonNo].playStatus == .Locked) {
                        //In-App Billing goes here
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(SublevelEvents.EventComplete.toRaw(), object:self)
                        return
                    }
                }
            }
        }
    }
}
