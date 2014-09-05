//
//  GameScene.swift
//  Balance
//
//  Created by CraigGrummitt on 4/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit
import CoreMotion

enum GameEvents:String {
    case EventSuccess="Event Success"
    case EventFail="Event Fail"
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    //enums,consts
    enum GameStatus:Int {
        case STARTING = 1
        case READY_FOR_CLICK = 2
        case PLAYING_GAME = 3
        case GAME_OVER = 4
        case PENDING = 5
    }
    enum ColliderType:UInt32 {
        case ManCategory = 1
        case ObjectCategory = 2
        case BorderCategory = 3
        case BallCategory = 4
    }
    let TAP_DISTANCE = Float(100)
    let OBJECT_TIME = NSTimeInterval(3)
    let OBJECT_DROP_TIME = NSTimeInterval(6)
    let BALL_TIME = NSTimeInterval(11)
    
    let cm = ConfigurationManager.sharedInstance
    let deviceType:DeviceType=ConfigurationManager.sharedInstance.getDeviceType()
    //display objects
    let titleLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    let numberLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    let subtitleLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    let scoreLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    let objectiveLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
    var man:Man!
    var objects:Array<SKSpriteNode>=[]
    var arrowRight:SKSpriteNode!
    var arrowLeft:SKSpriteNode!
    var borderBody:SKPhysicsBody!
    var object:SKSpriteNode!
    var ball:SKSpriteNode?
    var exit:SKSpriteNode?
    //atlas
    var imagesAtlas:SKTextureAtlas
    //vars
    var currentObjectNo:Int!
    var manDirection=Float(0)
    var manSpeed=Float(3)
    var gameStatus:Int = GameStatus.STARTING.toRaw()
    var lastUpdateTimeInterval=NSTimeInterval(0)
    var lastObjectSpawnTimeInterval=NSTimeInterval(0)
    var lastBallSpawnTimeInterval=NSTimeInterval(0)
    let motionManager = CMMotionManager()
    var square1:SKShapeNode!
    var objectAdded:Bool=false
    var score:Int=0
    var objectsFactory:Objects!
    var subLevelVO:SubLevelVO
    
    init(imagesAtlas:SKTextureAtlas, subLevelVO:SubLevelVO, size: CGSize) {
        self.subLevelVO=subLevelVO
        self.imagesAtlas=imagesAtlas
        deviceType = ConfigurationManager.sharedInstance.getDeviceType()
        super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func playLevel(subLevelVO:SubLevelVO) {
        self.subLevelVO=subLevelVO
        showIntroLabels()
        resetMan()
    }
    override func didMoveToView(view: SKView) {
        motionManager.accelerometerUpdateInterval = (1/40)
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        self.backgroundColor = SKColor.whiteColor()
        
        borderBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: -100, y: 0), toPoint: CGPoint(x: self.view.bounds.width+100,y: 0))
        borderBody.categoryBitMask=ColliderType.BorderCategory.toRaw()
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0;
        
        createMan()
        createLabels()
        objectsFactory=Objects(imagesAtlas: imagesAtlas)
        createArrows()
        showIntroLabels()
        
    }
    func createArrows() {
        var arrowRightTexture=cm.getImageTexture("arrowRight")
        arrowRight = SKSpriteNode(texture: arrowRightTexture)
        arrowRight.position = CGPoint(x: self.view.bounds.width-arrowRight.size.width, y: CGRectGetMidY(self.view.bounds)-arrowRight.size.height/2)
        arrowLeft = SKSpriteNode(texture: arrowRightTexture)
        arrowLeft.position = CGPoint(x: arrowLeft.size.width, y: CGRectGetMidY(self.view.bounds)-arrowLeft.size.height/2)
        arrowLeft.xScale = -1
    }
    func changeStatusToReadyForClick() {
        gameStatus=GameStatus.READY_FOR_CLICK.toRaw()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameStatus==GameStatus.STARTING.toRaw() {return}
        
        var foundTouch = false
        for touch: AnyObject in touches {
            foundTouch=true
            let location = touch.locationInNode(self)
        }
        if foundTouch {
            if gameStatus==GameStatus.READY_FOR_CLICK.toRaw() || gameStatus==GameStatus.GAME_OVER.toRaw() {
                if (gameStatus==GameStatus.GAME_OVER.toRaw()) {
                    removeObjects()
                  //  removeBall()
                    self.lastObjectSpawnTimeInterval = 0
                    self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
                    if let exitUnwrapped=exit {
                        self.removeChildrenInArray([exitUnwrapped])
                        exit=nil
                    }
                    resetMan()
                } else {
                    if (scoreLabel.parent==nil) { self.addChild(scoreLabel) }
                    if (objectiveLabel.parent==nil) {self.addChild(objectiveLabel) }
                }
                updateScore(0)
                gameStatus=GameStatus.PLAYING_GAME.toRaw()
                titleLabel.runAction(flyOff(titleLabel))
                numberLabel.runAction(flyOff(numberLabel))
                subtitleLabel.runAction(flyOff(subtitleLabel))
                man.physicsBody.dynamic = true
                //display arrows
                self.addChild(arrowRight)
                self.addChild(arrowLeft)
                var queue=NSOperationQueue()
                motionManager.accelerometerUpdateInterval = (1/40)
                motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) in
                    self.updateAcceleration(accelerometerData.acceleration)
                })
                playSqueak()

            } else if gameStatus==GameStatus.PLAYING_GAME.toRaw() {
                var touch: UITouch = touches.anyObject() as UITouch
                let location = touch.locationInNode(self)
                if (location.x>self.view.bounds.width-CGFloat(TAP_DISTANCE)) { //go right
                    //manDirection=Float(1)
                    man.physicsBody.applyImpulse(CGVectorMake(200,0))
                    startWalkingMan()
                } else if (location.x<CGFloat(TAP_DISTANCE)) {                  //go left
                    man.physicsBody.applyImpulse(CGVectorMake(-200,0))
                    startWalkingMan()
                //} else {                                                        //jump
                //    man.physicsBody.applyImpulse(CGVectorMake(0,4000))
                }
            }
        }
    }
    func playSqueak() {
        //can't find AVFoundation for some reason, come back to this in next version of XCode beta
/*        var audioPlayer = AVAudioPlayer()
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bikeSqueak", ofType: "mp3"))
        println(alertSound)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()*/
    }
    func updateScore(newScore:Int) {
        score=newScore
        scoreLabel.text="Balancing : \(score)"
        objectiveLabel.text="Must balance : \(self.subLevelVO.mustBalance)"
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if gameStatus==GameStatus.PLAYING_GAME.toRaw() {
            //manDirection=0
            //stopWalkingMan()
        }
    }
    //----------------------------------------------------------------------
    // labels
    func createLabels() {
        titleLabel.text = "MUST"
        subtitleLabel.text = "Touch to continue"
        titleLabel.fontSize = 65
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:CGRectGetMidY(self.view.bounds)-titleLabel.frame.height/2)
        
        numberLabel.text = "1"
        numberLabel.fontSize = 130
        numberLabel.fontColor = UIColor.blackColor()
        numberLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:CGRectGetMidY(self.view.bounds)-titleLabel.frame.height/2)
        numberLabel.hidden = true
        
        subtitleLabel.fontSize = 14
        subtitleLabel.fontColor = UIColor.blackColor()
        subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:titleLabel.position.y-subtitleLabel.frame.height-10)
        subtitleLabel.hidden=true
        
        scoreLabel.fontSize = 20
        scoreLabel.fontColor=UIColor.blackColor()
        scoreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        scoreLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        scoreLabel.position=CGPoint(x: 10, y:view.bounds.height-scoreLabel.frame.height-10)
        
        objectiveLabel.fontSize = 20
        objectiveLabel.fontColor=UIColor.blackColor()
        objectiveLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Right
        objectiveLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        objectiveLabel.position=CGPoint(x: view.bounds.width-objectiveLabel.frame.width-10, y:view.bounds.height-scoreLabel.frame.height-10)
        self.addChild(titleLabel)
        self.addChild(self.subtitleLabel)
        self.addChild(self.numberLabel)
    }
    func showIntroLabels() {
        titleLabel.text = "MUST"
        subtitleLabel.text = "Touch to continue"
        self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        self.titleLabel.runAction(SKEase.scaleFromWithNode(titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
            self.titleLabel.text = "MUST BALANCE"
            self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
            self.titleLabel.runAction(SKEase.scaleFromWithNode(self.titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
                self.numberLabel.text = "\(self.subLevelVO.mustBalance)"
                self.numberLabel.hidden = false
                self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
                self.titleLabel.runAction(SKEase.moveToWithNode(self.titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, toVector: CGVector(self.titleLabel.position.x,self.titleLabel.position.y+self.numberLabel.frame.height)))
                self.numberLabel.runAction(SKEase.scaleFromWithNode(self.numberLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
                    self.runAction(SKAction.playSoundFileNamed("woosh_3.mp3", waitForCompletion: false))
                    self.subtitleLabel.hidden=false
                    self.subtitleLabel.position.x=CGRectGetMidX(self.view.bounds)
                    self.subtitleLabel.runAction(self.flyOn(self.subtitleLabel)) {
                        self.changeStatusToReadyForClick()
                    }
                }
            }
        }
    }
    func flyOn(node:SKNode)->SKAction {
        var action=SKEase.moveFromWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, fromVector: CGVectorMake(view.bounds.width+node.frame.width/2, node.position.y))
        return action
    }
    func flyOff(node:SKNode)->SKAction {
        var action=SKEase.moveToWithNode(node, easeFunction: .CurveTypeElastic, easeType: .EaseTypeIn, time: 1, toVector: CGVectorMake(-node.frame.width/2, node.position.y))
        return action
    }
    //----------------------------------------------------------------------
    // objects
    /*func setupObjects() {
        for i in 1...OBJECT_MAX {
            objectFrames.append(imagesAtlas.textureNamed("briefcase\(i)"+deviceType.toRaw()+".png"))
        }
    }*/
    func addObject() {
        objectAdded=true
        currentObjectNo = self.subLevelVO.objects[objects.count] //Int(rand()) % ObjectsConsts.OBJECT_MAX.toRaw()
        object=objectsFactory.getObject(currentObjectNo) //SKSpriteNode(texture: objectFrames[objectNo])
        var objectX = view.bounds.width/4 + CGFloat(arc4random()) % (view.bounds.width/2)
        object.position = CGPoint(x: objectX, y: view.bounds.height-10-object.size.height/2)
        self.addChild(object)
        
        var action=SKEase.moveFromWithNode(object, easeFunction: .CurveTypeElastic, easeType: .EaseTypeIn, time: 0.5, fromVector: CGVectorMake(object.position.x,view.bounds.height+object.size.height/2))
        object.runAction(action)
        objects.append(object)
        self.runAction(SKAction.waitForDuration(4.5)) {
            self.updateScore(self.score+1)
        }
    }
    func dropObject() {
        objectsFactory.generatePhysics(object, objectNo: currentObjectNo)
    }
    func removeObjects() {
        self.removeChildrenInArray(objects)
        objects=[]
    }
    func updateObject(timeSinceLast:CFTimeInterval) {
        if (!objectAdded && self.objects.count==self.subLevelVO.mustBalance) {
            if let exitUnwrapped=exit {
                return
            } else {
                exit=SKSpriteNode(texture: cm.getImageTexture("exit"))
                exit!.position=CGPoint(x: 10, y: exit!.size.height)
                exit!.zPosition=0
                self.addChild(exit)
                return
            }
        }
        self.lastObjectSpawnTimeInterval += timeSinceLast
        if (self.lastObjectSpawnTimeInterval > OBJECT_TIME && !objectAdded) {
            self.runAction(SKAction.playSoundFileNamed("woosh_3.mp3", waitForCompletion: false))
            addObject()
        } else if (self.lastObjectSpawnTimeInterval > OBJECT_DROP_TIME) {
            self.lastObjectSpawnTimeInterval = 0
            objectAdded=false
            dropObject()
            self.runAction(SKAction.playSoundFileNamed("fall.mp3", waitForCompletion: false), withKey: "fall")
        }
    }
    
        //----------------------------------------------------------------------
    // balls
/*    func addBall() {
        ball=SKSpriteNode(texture: imagesAtlas.textureNamed("ball"+getDeviceType().toRaw()+".png"))
        ball!.position=CGPoint(x: ball!.size.width/2, y: ball!.size.height/2)
        ball!.physicsBody = SKPhysicsBody(circleOfRadius: ball!.size.width/2)
        ball!.physicsBody.categoryBitMask = ColliderType.BallCategory.toRaw()  //what's this?
        ball!.physicsBody.contactTestBitMask = ColliderType.ManCategory.toRaw() //what to notify contact of
        ball!.physicsBody.collisionBitMask = ColliderType.ManCategory.toRaw() | ColliderType.ObjectCategory.toRaw() | ColliderType.BorderCategory.toRaw() //what to bounce off
        ball!.physicsBody.friction=0.0
        ball!.physicsBody.linearDamping=0.0
        ball!.physicsBody.mass=1
        ball!.physicsBody.dynamic = true
        self.addChild(ball!)
        ball!.physicsBody.applyImpulse(CGVectorMake(300,0))
    }
    func removeBallIfOffScreen() {
        if let theBall=ball {
            if (theBall.position.x>self.view.bounds.width) {
                self.removeChildrenInArray([theBall])
                ball=nil
            }
        }
    }
    func removeBall() {
        if let theBall=ball {
            self.removeChildrenInArray([theBall])
            ball=nil
        }
    }
    func updateBall(timeSinceLast:CFTimeInterval) {
        self.lastBallSpawnTimeInterval += timeSinceLast
        if (self.lastBallSpawnTimeInterval > BALL_TIME) {
            self.lastBallSpawnTimeInterval = 0
            addBall()
        } else {
            removeBallIfOffScreen()
        }
    }*/
    //----------------------------------------------------------------------
    // man
    func createMan() {
        man=Man(imagesAtlas: imagesAtlas)
        man.position = CGPointMake(CGRectGetMidX(self.view.bounds),man.frame.height/2)
        self.addChild(man)
        self.animateManToCentreOfScreen()

    }
    func resetMan() {
        man.position = CGPointMake(view.bounds.width/2,10+man.frame.height/2)
        man.zRotation=0
    }
    func stopWalkingMan() {
        man.stopWalking()
    }
    func startWalkingMan() {
        man.startWalking()
    }
    func animateManToCentreOfScreen() {
        man.runAction(SKEase.fadeFromWithNode(man, easeFunction: .CurveTypeLinear, easeType: .EaseTypeIn, time: 1, fromValue: 0))
    }
    func updateMan() {
        man.update()
    }
    //----------------------------------------------------------------------
    //
    override func update(currentTime: CFTimeInterval) {
        if gameStatus==GameStatus.PLAYING_GAME.toRaw() {
            /* Called before each frame is rendered */
            var timeSinceLast = currentTime - self.lastUpdateTimeInterval
            self.lastUpdateTimeInterval = currentTime
            if (timeSinceLast > 1) {
                timeSinceLast = 1.0 / 60.0
                self.lastUpdateTimeInterval = currentTime
            }
            updateObject(timeSinceLast)
         //   updateBall(timeSinceLast)
            updateMan()
            if (man.position.x<0) {
                if let exitUnwrapped=exit {
                    success()
                }
            }
        }
    }
    func updateAcceleration(acceleration:CMAcceleration) {
        self.physicsWorld.gravity.dx=CGFloat(acceleration.x)
    }
    func success() {
        NSNotificationCenter.defaultCenter().postNotificationName(GameEvents.EventSuccess.toRaw(), object:self)
/*        self.removeChildrenInArray([arrowLeft,arrowRight])
        removeObjects()
        titleLabel.text = "Level complete!"
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:CGRectGetMidY(self.view.bounds)-titleLabel.frame.height/2)
        gameStatus=GameStatus.PENDING.toRaw()
        self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        self.titleLabel.runAction(SKEase.scaleFromWithNode(titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1.5, fromValue: 0)) {
//            self.subtitleLabel.text="Touch to play next level"
 //           self.subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:self.subtitleLabel.position.y)
  //          self.subtitleLabel.runAction(self.flyOn(self.subtitleLabel)) {
                NSNotificationCenter.defaultCenter().postNotificationName(GameEvents.EventSuccess.toRaw(), object:self)
   //         }
        }*/
    }
    func gameOver() {
         NSNotificationCenter.defaultCenter().postNotificationName(GameEvents.EventFail.toRaw(), object:self)
/*       self.removeChildrenInArray([arrowLeft,arrowRight])
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);
        motionManager.stopAccelerometerUpdates()
        objectAdded=false
        gameStatus=GameStatus.PENDING.toRaw()
        titleLabel.text = "Game Over!"
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:titleLabel.position.y)


        man.physicsBody.dynamic=false
        stopWalkingMan()
        self.runAction(SKAction.playSoundFileNamed("grenade.mp3", waitForCompletion: false))
        self.titleLabel.runAction(SKEase.scaleFromWithNode(titleLabel, easeFunction: .CurveTypeElastic, easeType: .EaseTypeOut, time: 1, fromValue: 0)) {
            self.runAction(SKAction.playSoundFileNamed("woosh_3.mp3", waitForCompletion: false))
            self.subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:self.subtitleLabel.position.y)
            self.subtitleLabel.runAction(self.flyOn(self.subtitleLabel)) {
                self.changeStatusToGameOver()
            }
        }*/
    }
    func changeStatusToGameOver() {
        gameStatus = GameStatus.GAME_OVER.toRaw()
    }
    func didBeginContact(contact: SKPhysicsContact!) {
        var firstBody,secondBody:SKPhysicsBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if gameStatus==GameStatus.PLAYING_GAME.toRaw() {
            println("COLLIDE \(firstBody.categoryBitMask) and \(secondBody.categoryBitMask)")
            if ((firstBody.categoryBitMask & ColliderType.ObjectCategory.toRaw() == ColliderType.ObjectCategory.toRaw()) &&
                (secondBody.categoryBitMask & ColliderType.BorderCategory.toRaw() == ColliderType.BorderCategory.toRaw()) ) {
                    gameOver()
            } else if ((firstBody.categoryBitMask == ColliderType.ObjectCategory.toRaw() && secondBody.categoryBitMask == ColliderType.ObjectCategory.toRaw())
            || (firstBody.categoryBitMask == ColliderType.ManCategory.toRaw() && secondBody.categoryBitMask == ColliderType.ObjectCategory.toRaw())) {
                //self.removeActionForKey("fall")
                //self.runAction(SKAction.playSoundFileNamed("land.mp3", waitForCompletion: false))
            } /*else if ((firstBody.categoryBitMask == ColliderType.ManCategory.toRaw()) &&
                (secondBody.categoryBitMask == ColliderType.BallCategory.toRaw())) {
                    println("MAN HIT BALL \(firstBody.categoryBitMask), \(secondBody.categoryBitMask)")
                    gameOver()
            }*/
        }

    }
}
