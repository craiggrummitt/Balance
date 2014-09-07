//
//  Background.swift
//  Balance
//
//  Created by CraigGrummitt on 5/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    var cm=ConfigurationManager.sharedInstance
    var backgroundSprites:Array<SKSpriteNode>=[]
    var sceneWidth:CGFloat
    init(backgroundTextureNames:Array<String>,sceneWidth:CGFloat) {
        self.sceneWidth = sceneWidth
        super.init()
        var goingUp = CGFloat(0.0)
        for name in backgroundTextureNames {
            var sprite = SKSpriteNode(texture: cm.getImageTexture(name))
            sprite.position = CGPoint(x: sceneWidth / 2, y: CGFloat(goingUp) + sprite.frame.height / 2)
            goingUp+=sprite.frame.height
            self.addChild(sprite)
            backgroundSprites.append(sprite)
        }
    }
    func update(frac:CGFloat) {
        for sprite in backgroundSprites {
            sprite.position.x = (sceneWidth / CGFloat(2.0)) - ((frac / CGFloat(2.0) * (sprite.frame.width - sceneWidth)))
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
