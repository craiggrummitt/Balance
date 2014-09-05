//
//  LevelScene.swift
//  Balance
//
//  Created by CraigGrummitt on 1/09/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit


enum LevelEvents:String {
    case EventComplete="LevelEventComplete"
    case EventBack="LevelEventBack"
}

class LevelScene: SKScene {
    var cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType = ConfigurationManager.sharedInstance.getDeviceType()
    var levels:Array<LevelVO>
    var levelTitleImages:Array<SKSpriteNode>=[]
    var swipeRightGesture:UISwipeGestureRecognizer!
    var swipeLeftGesture:UISwipeGestureRecognizer!
    var titleImageHolder:SKNode=SKNode()
    var currentLevelNo:Int
    var backButton:SKSpriteNode!
    var touchBeginPoint:CGPoint!
    var backDown:Bool=false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(levels:Array<LevelVO>, size: CGSize) {
        self.levels=levels
        self.currentLevelNo = 0
        super.init(size:size)
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor.whiteColor()
        self.addChild(titleImageHolder)
        for var levelNo = 0;levelNo<self.levels.count;levelNo++ {
            var level = levels[levelNo]
            var levelTitleImage = SKSpriteNode(texture: cm.getImageTexture(level.titleImage))
            levelTitleImage.position=CGPoint(x:CGRectGetMidX(self.view.bounds)+(CGFloat(levelNo)*self.view.bounds.width), y:CGRectGetMidY(self.view.bounds))
            titleImageHolder.addChild(levelTitleImage)

            levelTitleImages.append(levelTitleImage)
        }
        var firstTitleImage = levelTitleImages[0]
        firstTitleImage.runAction(SKEase.moveFromWithNode(firstTitleImage, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, fromVector: CGVectorMake(view.bounds.width+firstTitleImage.frame.width/2, firstTitleImage.position.y)))
        
        
        //gestures
        swipeRightGesture=UISwipeGestureRecognizer(target: self, action: Selector("handleRight:"))
        swipeLeftGesture=UISwipeGestureRecognizer(target: self, action: Selector("handleLeft:"))
        swipeRightGesture.direction = .Right
        swipeLeftGesture.direction = .Left
        //swipeRightGesture.cancelsTouchesInView=false
        //swipeLeftGesture.cancelsTouchesInView=false
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        
        
        backButton = SKSpriteNode(texture: cm.getImageTexture("back"))
        backButton.position=CGPoint(x:100,y:100)
        backButton.name="backButton"
        self.addChild(backButton)
    }
    override func willMoveFromView(view: SKView!) {
        view.removeGestureRecognizer(swipeRightGesture)
    }
    func handleRight(recognizer: UISwipeGestureRecognizer) {
        if (currentLevelNo>0) {
            currentLevelNo--
        }
    }
    func animateToVector() {
        var toVector=CGVectorMake(-CGFloat(currentLevelNo)*view.bounds.width, titleImageHolder.position.y)
        self.titleImageHolder.runAction(SKEase.moveToWithNode(self.titleImageHolder, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, toVector: toVector))
    }
    func handleLeft(recognizer: UISwipeGestureRecognizer) {
        if (currentLevelNo<self.levels.count-1) {
            currentLevelNo++
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
        } else {
            var translation = CGPoint(x: positionInScene.x - previousPosition.x,y: positionInScene.y - previousPosition.y)
            self.titleImageHolder.position.x = self.titleImageHolder.position.x+translation.x
        }
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        touchBeginPoint = touches.anyObject().locationInNode(self)
        var node = self.nodeAtPoint(touchBeginPoint)
        if (node == self.backButton) {
            self.backButton.texture = cm.getImageTexture("backDown")
            backDown=true
        }
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        println("touches ended")
        var touchEndPoint = touches.anyObject().locationInNode(self)
        var node = self.nodeAtPoint(touchEndPoint)
        if (backDown && node==self.backButton) {
            NSNotificationCenter.defaultCenter().postNotificationName(LevelEvents.EventBack.toRaw(), object:self)
        } else {
            if (abs(distanceBetween(p1: touchBeginPoint, p2: touchEndPoint))<10) {
                NSNotificationCenter.defaultCenter().postNotificationName(LevelEvents.EventComplete.toRaw(), object:self)
            } else {
                animateToVector()
            }
        }

    }
    func distanceBetween(#p1:CGPoint,p2:CGPoint)->Int {
        var aaaa = Float(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2))
        return Int(sqrtf(aaaa))
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        println("touches cancelled")
        animateToVector()
    }
}
