//
//  LevelVO.swift
//  Balance
//
//  Created by CraigGrummitt on 29/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import Foundation
class LevelVO {
    var titleImage:String!
    var subLevels:Array<SubLevelVO>!
    init(titleImage:String,subLevels:Array<SubLevelVO>) {
        self.titleImage=titleImage
        self.subLevels=subLevels
    }
}