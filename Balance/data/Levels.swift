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
            LevelVO(titleImage: "level1",subLevels: [SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus: .NoSuccess),
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
                SubLevelVO(mustBalance: 10, objects: [0,1,2,3,4,5,6,0,1,2], playStatus:.Locked)]),
            LevelVO(titleImage: "level2",subLevels: [SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 6, objects: [0,1,2,3,4,5], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 8, objects: [0,1,2,3,0,2,3,2], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.NoSuccess),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 4, objects: [0,1,2,3], playStatus:.Locked),
                SubLevelVO(mustBalance: 10, objects: [0,1,2,3,4,5,6,0,1,2], playStatus:.Locked)])
                ]
    }
}