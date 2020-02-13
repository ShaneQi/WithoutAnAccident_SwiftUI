//
//  Accident+CoreDataClass.swift
//  WithoutAnAccident
//
//  Created by Zengtai Qi on 2/12/20.
//  Copyright © 2020 Shane Qi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Accident)
public class Accident: NSManagedObject {

}

extension Accident {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accident> {
        return NSFetchRequest<Accident>(entityName: "Accident")
    }

    @NSManaged public var happenedAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var journey: Journey

}
