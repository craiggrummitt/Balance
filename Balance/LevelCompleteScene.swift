//
//  LevelCompleteScene.swift
//  Balance
//
//  Created by CraigGrummitt on 4/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

class LevelCompleteScene: SKScene {
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    var success:Bool = false
    var titleLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    var nextButton:SKSpriteNode!
    var menuButton:SKSpriteNode!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(success:Bool, size: CGSize) {
        self.success=success
        super.init(size:size)
    }
    override func didMoveToView(view: SKView!) {
        self.backgroundColor = SKColor.whiteColor()
        self.nextButton = createButton("NEXT")
        self.menuButton = createButton("MENU")
        self.nextButton.position = CGPoint(x:CGRectGetMidX(self.view.bounds)-110, y:CGRectGetMidY(self.view.bounds))
        self.menuButton.position = CGPoint(x:CGRectGetMidX(self.view.bounds)+110, y:CGRectGetMidY(self.view.bounds))
        self.addChild(self.nextButton)
        self.addChild(self.menuButton)
        self.nextButton.hidden=true
        self.menuButton.hidden=true
        
        if (success) {
            titleLabel.text = "WELL DONE! LEVEL COMPLETE!"
            self.runAction(SKAction.playSoundFileNamed("011436082-level-complete-2.mp3", waitForCompletion: false))
        } else {
            titleLabel.text = "BAD LUCK!"
            self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        }
        titleLabel.fontSize = 65
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:CGRectGetMidY(self.view.bounds)-titleLabel.frame.height/2)
        self.addChild(titleLabel)
        self.titleLabel.runAction(SKEase.scaleFromWithNode(titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
            self.nextButton.hidden=false
            self.menuButton.hidden=false
            self.titleLabel.runAction(SKEase.moveToWithNode(self.titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, toVector: CGVector(self.titleLabel.position.x,self.titleLabel.position.y+self.titleLabel.frame.height/2+self.nextButton.frame.height/2)))
            self.nextButton.runAction(SKEase.scaleFromWithNode(self.nextButton, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0))
            self.menuButton.runAction(SKEase.scaleFromWithNode(self.menuButton, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0))
        }
    }
    func createButton(text:String)->SKSpriteNode {
        var buttonNode = SKSpriteNode(texture: cm.getImageTexture("button"))
        var buttonLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
        buttonLabel.text = "\(text)"
        buttonLabel.zPosition=1
        buttonLabel.fontSize = 45
        buttonLabel.fontColor = UIColor.blackColor()
        buttonLabel.position = CGPoint(x:0, y:-10)
        buttonNode.addChild(buttonLabel)
        return(buttonNode)
    }
    
}
