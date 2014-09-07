//
//  SKButton.swift
//  Balance
//
//  Created by CraigGrummitt on 4/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

@objc protocol SKButtonDelegate {
    optional func buttonDown(button:SKButton)
    optional func buttonUp(button:SKButton)
    optional func buttonDownCancel(button:SKButton)
}

class SKButton: SKSpriteNode {
    var offTexture:SKTexture
    var downTexture:SKTexture
    var text:String
    var delegate:SKButtonDelegate?
    var buttonDown:Bool = false
    
    init(offTexture:SKTexture,downTexture:SKTexture,text:String="",labelPos:CGPoint=CGPoint(x:0,y:-10)) {
        self.offTexture=offTexture
        self.downTexture=downTexture
        self.text=text
        super.init(texture: offTexture, color: UIColor.clearColor(), size: offTexture.size())
        if (text != "") {
            var buttonLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
            buttonLabel.text = "\(text)"
            buttonLabel.zPosition=1
            buttonLabel.fontSize = 45
            buttonLabel.fontColor = UIColor.blackColor()
            buttonLabel.position = labelPos
            self.addChild(buttonLabel)
        }
        self.userInteractionEnabled=true
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.texture = downTexture
        buttonDown = true
        self.delegate?.buttonDown?(self)
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (buttonDown) {
            super.touchesEnded(touches, withEvent: event)
            self.texture = offTexture
            self.delegate?.buttonUp?(self)
            buttonDown=false
        }
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        self.texture = offTexture
        self.delegate?.buttonDownCancel?(self)
        buttonDown=false
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if (buttonDown) {
            var touch: AnyObject = touches.anyObject()!
            var positionInScene = touch.locationInNode(self.parent)
            if (!self.containsPoint(positionInScene)) {
                touchesCancelled(touches, withEvent: event)
            }
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
