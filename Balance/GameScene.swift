//
//  GameScene.swift
//  Balance
//
//  Created by CraigGrummitt on 4/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import SpriteKit
import CoreMotion

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
    let OBJECT_MAX = 3
    let TAP_DISTANCE = Float(100)
    let OBJECT_TIME = NSTimeInterval(5)
    let OBJECT_DROP_TIME = NSTimeInterval(8)
    let BALL_TIME = NSTimeInterval(11)
    //display objects
    let titleLabel = SKLabelNode(fontNamed:"Avenir-Light")
    let subtitleLabel = SKLabelNode(fontNamed:"Avenir-Light")
    let scoreLabel = SKLabelNode(fontNamed:"Avenir-Light")
    let highScoreLabel = SKLabelNode(fontNamed:"Avenir-Light")
    var man:Man!
    var objects:Array<SKSpriteNode>=[]
    var arrowRight:SKSpriteNode!
    var arrowLeft:SKSpriteNode!
    var borderBody:SKPhysicsBody!
    var object:SKSpriteNode!
    var ball:SKSpriteNode?
    //atlas
    var imagesAtlas = SKTextureAtlas(named: "images")
    var objectFrames:Array<SKTexture>=[]
    //vars
    var deviceType:DeviceType!//attempted to place this in lazy var without success
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
    var highScore:Int=10
    
    override func didMoveToView(view: SKView) {
        
        motionManager.accelerometerUpdateInterval = (1/40)
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        deviceType = ConfigurationManager.sharedInstance.getDeviceType()
        self.backgroundColor = SKColor.whiteColor()
        
        borderBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: -100, y: 0), toPoint: CGPoint(x: self.view.bounds.width+100,y: 0))
        borderBody.categoryBitMask=ColliderType.BorderCategory.toRaw()
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0;
        
        createLabels()
        createMan()
        setupObjects()
        createArrows()
        
    }
    func createArrows() {
        var arrowRightTexture=imagesAtlas.textureNamed("arrowRight"+deviceType.toRaw()+".png")
        arrowRight = SKSpriteNode(texture: arrowRightTexture)
        arrowRight.position = CGPoint(x: self.view.bounds.width-arrowRight.size.width, y: CGRectGetMidY(self.view.bounds)-arrowRight.size.height/2)
        arrowLeft = SKSpriteNode(texture: arrowRightTexture)
        arrowLeft.position = CGPoint(x: arrowLeft.size.width, y: CGRectGetMidY(self.view.bounds)-arrowLeft.size.height/2)
        arrowLeft.xScale = -1
    }
    func setReadyForClick() {
        self.stopWalkingMan()
        self.addChild(subtitleLabel)
        subtitleLabel.runAction(flyOn(subtitleLabel)) {
            self.changeStatusToReadyForClick()
        }
        gameStatus=GameStatus.PENDING.toRaw()
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
                    
                    resetMan()
                } else {
                    self.addChild(scoreLabel)
                    self.addChild(highScoreLabel)
                }
                updateScore(0)
                gameStatus=GameStatus.PLAYING_GAME.toRaw()
                titleLabel.runAction(flyOff(titleLabel))
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

            } else if gameStatus==GameStatus.PLAYING_GAME.toRaw() {
                var touch: UITouch = touches.anyObject()! as UITouch
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
    func updateScore(newScore:Int) {
        score=newScore
        scoreLabel.text="Score: \(score)"
        if (score>highScore) {
            highScore=score
        }
        highScoreLabel.text="High score: \(highScore)"
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
        titleLabel.text = "Balance!"
        titleLabel.fontSize = 65
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:CGRectGetMidY(self.view.bounds)-titleLabel.frame.height/2)
        
        subtitleLabel.text = "Touch to continue"
        subtitleLabel.fontSize = 14
        subtitleLabel.fontColor = UIColor.blackColor()
        subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:titleLabel.position.y-subtitleLabel.frame.height-10)
        
        scoreLabel.fontSize = 20
        scoreLabel.fontColor=UIColor.blackColor()
        scoreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        scoreLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        scoreLabel.position=CGPoint(x: 10, y:view.bounds.height-scoreLabel.frame.height-10)
        
        highScoreLabel.fontSize = 20
        highScoreLabel.fontColor=UIColor.blackColor()
        highScoreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Right
        highScoreLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        highScoreLabel.position=CGPoint(x: view.bounds.width-highScoreLabel.frame.width-10, y:view.bounds.height-scoreLabel.frame.height-10)
        self.addChild(titleLabel)
        titleLabel.runAction(flyOn(titleLabel))
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
    func setupObjects() {
        for i in 1...OBJECT_MAX {
            objectFrames.append(imagesAtlas.textureNamed("briefcase\(i)"+deviceType.toRaw()+".png"))
        }
    }
    func addObject() {
        objectAdded=true
        var objectNo = Int(rand()) % OBJECT_MAX

        object=SKSpriteNode(texture: objectFrames[objectNo])
        var objectX = view.bounds.width/4 + CGFloat(arc4random()) % (view.bounds.width/2)
        object.position = CGPoint(x: objectX, y: view.bounds.height-10-object.size.height/2)
        self.addChild(object)
        
        var action=SKEase.moveFromWithNode(object, easeFunction: .CurveTypeElastic, easeType: .EaseTypeIn, time: 0.5, fromVector: CGVectorMake(object.position.x,view.bounds.height+object.size.height/2))
        object.runAction(action)
        objects.append(object)
        updateScore(score+1)
    }
    func dropObject() {
        object.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: object.size.width, height: object.size.height))
        object.physicsBody.categoryBitMask = ColliderType.ObjectCategory.toRaw()  //what's this?
        object.physicsBody.contactTestBitMask = ColliderType.ManCategory.toRaw() //what to notify contact of
        object.physicsBody.collisionBitMask = ColliderType.ManCategory.toRaw() | ColliderType.ObjectCategory.toRaw() | ColliderType.BorderCategory.toRaw() //what to bounce off
        object.physicsBody.friction=1.0
        object.physicsBody.linearDamping=1.0
        object.physicsBody.mass=1
        object.physicsBody.dynamic = true
    }
    func removeObjects() {
        self.removeChildrenInArray(objects)
        objects=[]
    }
    func updateObject(timeSinceLast:CFTimeInterval) {
        self.lastObjectSpawnTimeInterval += timeSinceLast
        if (self.lastObjectSpawnTimeInterval > OBJECT_TIME && !objectAdded) {
            addObject()
        } else if (self.lastObjectSpawnTimeInterval > OBJECT_DROP_TIME) {
            self.lastObjectSpawnTimeInterval = 0
            objectAdded=false
            dropObject()
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
        man.position = CGPointMake(view.bounds.width,10+man.frame.height/2)
        self.addChild(man)
        self.startWalkingMan()
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
        var action = SKAction.moveTo(CGPointMake(CGRectGetMidX(self.view.bounds),10+man.frame.height/2), duration: 4)
        man.runAction(action) {
            self.setReadyForClick()
        }
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
        }
    }
    func updateAcceleration(acceleration:CMAcceleration) {
        self.physicsWorld.gravity.dx=CGFloat(acceleration.x)
    }
    func gameOver() {
        self.removeChildrenInArray([arrowLeft,arrowRight])
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);
        motionManager.stopAccelerometerUpdates()
        objectAdded=false
        gameStatus=GameStatus.PENDING.toRaw()
        titleLabel.text = "Game Over!"
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:titleLabel.position.y)
        subtitleLabel.position = CGPoint(x:CGRectGetMidX(self.view.bounds), y:subtitleLabel.position.y)
        titleLabel.runAction(flyOn(titleLabel))
        man.physicsBody.dynamic=false
        stopWalkingMan()
        subtitleLabel.runAction(flyOn(subtitleLabel)) {
            self.changeStatusToGameOver()
        }
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
            if ((firstBody.categoryBitMask & ColliderType.ObjectCategory.toRaw() == ColliderType.ObjectCategory.toRaw()) &&
                (secondBody.categoryBitMask & ColliderType.BorderCategory.toRaw() == ColliderType.BorderCategory.toRaw()) ) {
                    gameOver()
            } else if ((firstBody.categoryBitMask == ColliderType.ManCategory.toRaw()) &&
                (secondBody.categoryBitMask == ColliderType.BallCategory.toRaw())) {
                    println("MAN HIT BALL \(firstBody.categoryBitMask), \(secondBody.categoryBitMask)")
                    gameOver()
            }
        }

    }
}
