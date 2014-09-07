//
//  SubLevel.swift
//  Balance
//
//  Created by CraigGrummitt on 29/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

import Foundation
enum PlayStatus {
    case Locked
    case NoSuccess
    case Success
}
class SubLevelVO {
    var mustBalance:Int
    var objects:Array<Int>
    var playStatus:PlayStatus
    init(mustBalance:Int,objects:Array<Int>,playStatus:PlayStatus) {
        self.mustBalance=mustBalance
        self.objects=objects
        self.playStatus=playStatus
    }
}