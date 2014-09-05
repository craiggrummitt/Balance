//
//  GameViewController.swift
//  Balance
//
//  Created by CraigGrummitt on 4/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
  /*  class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }*/
  /*  class func unarchiveFromFile(file : NSString) -> SKNode? {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }*/
}
extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

class GameViewController: UIViewController {
    var currentScene:SKScene!
    var subLevelNo:Int=0
    var levels:Array<LevelVO>=[]
    var imagesAtlas = SKTextureAtlas(named: "images")
    var size:CGSize!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goLevel:", name: TitleEvents.EventComplete.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goTitle:", name: LevelEvents.EventBack.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goSublevel:", name: LevelEvents.EventComplete.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goLevel:", name: SublevelEvents.EventBack.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goGame:", name: SublevelEvents.EventComplete.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goSuccess:", name: GameEvents.EventSuccess.toRaw(), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goFail:", name: GameEvents.EventFail.toRaw(), object: nil)
        allFonts()
    }
    func allFonts(){

       for family in UIFont.familyNames(){

           println(family)


           for name in UIFont.fontNamesForFamilyName(family.description)
           {
               println("  \(name)")
           }

       }

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ConfigurationManager.sharedInstance.setDeviceType(self.view.frame.width)
        levels=Levels().levels
        ConfigurationManager.sharedInstance.levels=levels
        ConfigurationManager.sharedInstance.imagesAtlas=self.imagesAtlas
       //if let scene = TitleScene.unarchiveFromFile("TitleScene") as? TitleScene {
        size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        goTitle(self)
       /* var scene = TitleScene(size: size)
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.showsPhysics=true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill

            skView.presentScene(scene)
            currentScene=scene

        }*/
    }
    func goTitle(sender:AnyObject) {
        showScene(TitleScene(size: size))
    }
    func goLevel(sender:AnyObject) {
        showScene(LevelScene(levels: levels, size: size))
    }
    func goSublevel(sender:AnyObject) {
        var levelNo = (currentScene as LevelScene).currentLevelNo
        showScene(SublevelScene(level: levels[levelNo], size: size))
    }
    func goGame(sender: AnyObject) {
        subLevelNo=(currentScene as SublevelScene).sublevelNo
        var subLevelVO = levels[0].subLevels[subLevelNo]
        showScene(GameScene(imagesAtlas: imagesAtlas, subLevelVO:subLevelVO, size: size))
    }
    func goSuccess(sender: AnyObject) {
        goLevelCompleteScene(true)
        
        /*subLevelNo++
        var subLevelVO = levels[0].subLevels[subLevelNo]
        (currentScene as GameScene).playLevel(subLevelVO)*/
    }
    func goFail(sender: AnyObject) {
        goLevelCompleteScene(false)
    }
    func goLevelCompleteScene(success:Bool) {
        showScene(LevelCompleteScene(success: success, size: size))
    }
    func showScene(whichScene:SKScene) {
        let skView = self.view as SKView
        skView.ignoresSiblingOrder = true
        whichScene.scaleMode = SKSceneScaleMode.ResizeFill
        var reveal = SKTransition.crossFadeWithDuration(0.5)

        skView.presentScene(whichScene, transition: reveal)
        currentScene=whichScene
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
