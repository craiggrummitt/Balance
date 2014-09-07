//
//  Levels.swift
//  Balance
//
//  Created by CraigGrummitt on 29/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

class Levels {
    var levels:Array<LevelVO>!
    init() {
        levels = [
            LevelVO(titleImage: "level1", imageName: "briefcase", objectTypeCount:7, backgroundTextures:["bg1_1","bg1_2","bg1_3"],
                subLevels:[
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus: .NoSuccess),
                SubLevelVO(mustBalance: 6, objects: [0,1,2,3,4,5], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 8, objects: [0,1,2,3,0,2,3,2], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 8, objects: [0,1,2,3,0,2,3,2], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 10, objects: [0,1,2,3,4,5,6,0,1,2], playStatus:.Locked)
            ]),
            LevelVO(titleImage: "level2", imageName: "block", objectTypeCount:10,backgroundTextures:["bg1_1","bg1_2","bg1_3"],
                subLevels: [
                SubLevelVO(mustBalance: 4, objects: [1,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 6, objects: [3,4,2,3,4,5], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [5,6,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 8, objects: [7,8,2,3,0,2,3,2], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [9,0,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 10, objects: [0,1,2,3,4,5,6,0,1,2], playStatus:.Locked)
            ])
        ]
    }
}