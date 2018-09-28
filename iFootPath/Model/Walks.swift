//
//  Walks.swift
//  iFootPath
//
//  Created by Viktor on 24.09.2018.
//  Copyright © 2018 Viktor. All rights reserved.
//

import Foundation

struct Walks: Decodable {
    let status         : String?
    let selected_locale: String?
    let walks          : [WalksInfo]?
    let total_count    : Int?
}

struct WalksInfo: Decodable {
//    let walkID            : String?
//    let walkVersion       : String?
    let walkTitle         : String?
//    let walkDescription   : String?
//    let walkLength        : String?
//    let walkGrade         : String?
//    let walkCounty        : String?
//    let walkDistrict      : String?
    let walkType          : String?
    let walkRating        : String?
//    let walkStartCoordLat : String?
//    let walkStartCoordLong: String?
    let walkIcon          : String?
//    let walkIllustration  : String?
//    let walkPublished     : String?
//    let walkPhoto         : String?
}
