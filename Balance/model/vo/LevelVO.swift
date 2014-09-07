//
//  LevelVO.swift
//  Balance
//
//  Created by CraigGrummitt on 29/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import Foundation
enum LevelNum {
    case LevelOne
    case LevelTwo
}
class LevelVO {
    var titleImage:String
    var imageName:String
    var objectTypeCount:Int
    var backgroundTextures:Array<String>
    var subLevels:Array<SubLevelVO>
    
    init(titleImage:String,imageName:String,objectTypeCount:Int,backgroundTextures:Array<String>,subLevels:Array<SubLevelVO>) {
        self.titleImage=titleImage
        self.imageName=imageName
        self.objectTypeCount=objectTypeCount
        self.backgroundTextures=backgroundTextures
        self.subLevels=subLevels
    }
}