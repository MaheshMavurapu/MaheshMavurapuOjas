//
//  Post+CoreDataProperties.swift
//  DownloadSample
//
//  Created by ojas on 17/11/19.
//  Copyright © 2019 ojas. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var points: Int16

}
