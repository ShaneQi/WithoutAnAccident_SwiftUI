//
//  Accident+CoreDataClass.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 2/12/20.
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
		let request = NSFetchRequest<Accident>(entityName: "Accident")
		request.sortDescriptors = [
			NSSortDescriptor(key: "happenedAt", ascending: false)
		]
		return request
	}

	@NSManaged public var happenedAt: Date
	@NSManaged public var id: UUID
	@NSManaged public var text: String
	@NSManaged public var journey: Journey

}

extension Accident: Identifiable {}
