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
class SublevelScene: SKScene {
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    var level:LevelVO
    var buttons:Array<SKSpriteNode>=[]
    var backButton:SKSpriteNode!
    var sublevelNo:Int!
    var backDown:Bool=false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(level:LevelVO, size: CGSize) {
        self.level=level
        super.init(size:size)
    }
    override func didMoveToView(view: SKView!) {
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
            var buttonNode = SKSpriteNode(texture: cm.getImageTexture(textureName))
            
            if (sublevel.playStatus != .Locked) {
                let buttonLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
                buttonLabel.text = "\(i+1)"
                buttonLabel.zPosition=1
                buttonLabel.fontSize = 45
                buttonLabel.fontColor = UIColor.blackColor()
                buttonLabel.position = CGPoint(x:-10, y:-10)
                buttonLabel.userInteractionEnabled=false
                buttonNode.addChild(buttonLabel)
            }
            
            var column:CGFloat = CGFloat(i%5)
            var row:Int = i/5
            
            buttonNode.position = CGPoint(x: 150.0+(column*125.0), y: self.view.bounds.height-200.0-CGFloat(row)*125.0)
            self.addChild(buttonNode)
            buttons.append(buttonNode)
        }
        
        backButton = SKSpriteNode(texture: cm.getImageTexture("back"))
        backButton.position=CGPoint(x:100,y:100)
        self.addChild(backButton)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        var touch: AnyObject = touches.anyObject()
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        if (node==self.backButton) {
            println("FOUND back button")
            self.backButton.texture = cm.getImageTexture("backDown")
            backDown=true
        } else {
            for buttonNo in 0..<buttons.count {
                let button = buttons[buttonNo]
                if (button.containsPoint(location)) {
//                if (node.isEqual(button)) {
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
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        var touchEndPoint = touches.anyObject().locationInNode(self)
        var node = self.nodeAtPoint(touchEndPoint)
        if (backDown && node==self.backButton) {
            NSNotificationCenter.defaultCenter().postNotificationName(SublevelEvents.EventBack.toRaw(), object:self)
        }
    }
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var touch: AnyObject = touches.anyObject()
        var positionInScene = touch.locationInNode(self)
        var previousPosition = touch.previousLocationInNode(self)
        if (backDown) {
            if (self.nodeAtPoint(positionInScene) != self.backButton) {
                self.backButton.texture = cm.getImageTexture("back")
                backDown=false
            }
        }
    }
}
