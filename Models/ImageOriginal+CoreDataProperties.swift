//
//  ImageOriginal+CoreDataProperties.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageOriginal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageOriginal> {
        return NSFetchRequest<ImageOriginal>(entityName: "ImageOriginal")
    }

    @NSManaged public var image: Data?

}
