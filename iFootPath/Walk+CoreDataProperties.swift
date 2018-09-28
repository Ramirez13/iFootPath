//
//  Walk+CoreDataProperties.swift
//  iFootPath
//
//  Created by Viktor on 28.09.2018.
//  Copyright © 2018 Viktor. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var walkTitle: String?
    @NSManaged public var walkType: String?
    @NSManaged public var walkIcon: String?
    @NSManaged public var walkRating: String?

}
