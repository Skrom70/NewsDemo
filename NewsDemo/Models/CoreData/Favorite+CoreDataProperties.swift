//
//  New+CoreDataProperties.swift
//  
//
//  Created by Viacheslav Tolstopianteko on 11.11.2022.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var abstract: String
    @NSManaged public var dateAdded: Date
    @NSManaged public var id: String
    @NSManaged public var imagePath: String?
    @NSManaged public var publishedDate: String
    @NSManaged public var title: String
    @NSManaged public var url: String

}
