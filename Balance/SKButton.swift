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
}

class SKButton: SKSpriteNode {
    var offTexture:SKTexture
    var downTexture:SKTexture
    var text:String
    var delegate:SKButtonDelegate?
    
    init(offTexture:SKTexture,downTexture:SKTexture,text:String) {
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
            buttonLabel.position = CGPoint(x:0, y:-10)
            self.addChild(buttonLabel)
        }
        self.userInteractionEnabled=true
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.texture = downTexture
        self.delegate?.buttonDown?(self)
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.texture = offTexture
        self.delegate?.buttonUp?(self)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
