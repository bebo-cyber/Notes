//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData


extension Note {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
//        return NSFetchRequest<Note>(entityName: "Note")
//    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int64
    @NSManaged public var subject: String?
    @NSManaged public var images: NSSet?

    
    @nonobjc public class func list(filter: String, _ block:(([Note]) -> ())?) {
        let request = NSFetchRequest<Note>(entityName: "Note")
        if !filter.isEmpty {
            request.predicate = .init(format: "subject CONTAINS[C] %@ OR content CONTAINS[C] %@", filter, filter)
        }
        do {
            let array = try AppDelegate.shared.managedObjectContainer.fetch(request)
            block?(array)
        } catch {
            print("Could not load save data: \(error.localizedDescription)")
            block?([])
        }
    }
    
    @nonobjc public class func save(_ block:((Bool) -> ())?) {

        do{
            try AppDelegate.shared.managedObjectContainer.save()
            block?(true)
        }catch{
            print("Could not save data: \(error.localizedDescription)")
            block?(false)
        }
    }
    
    
}

// MARK: Generated accessors for images
extension Note {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageOriginal)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageOriginal)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
