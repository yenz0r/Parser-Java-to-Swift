//
//  struct.swift
//  metrologiya
//
//  Created by Egor Pii on 10/17/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Foundation

struct elementInfo {
    var name : String = ""
    var count : Int

    init(inputName : String, inputCount : Int) {
        name = inputName
        count = inputCount
    }
}

typealias infoArr = [elementInfo]

struct functionInfo {
    var operatorsInfo : infoArr
    var operandsInfo : infoArr
    var separatorsInfo : infoArr
}
