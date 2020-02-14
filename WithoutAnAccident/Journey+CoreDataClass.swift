//
//  Journey+CoreDataClass.swift
//  WithoutAnAccident
//
//  Created by Zengtai Qi on 2/12/20.
//  Copyright © 2020 Shane Qi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Journey)
public class Journey: NSManagedObject {

}

extension Journey {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Journey> {
		let request = NSFetchRequest<Journey>(entityName: "Journey")
		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Journey.title, ascending: true)
		]
		return request
	}

	@NSManaged public var action: String
	@NSManaged public var id: UUID
	@NSManaged public var since: Date
	@NSManaged public var title: String
	@NSManaged public var accidents: NSSet?

}

// MARK: Generated accessors for accidents
extension Journey {

	@objc(addAccidentsObject:)
	@NSManaged public func addAccident(_ value: Accident)

	@objc(removeAccidentsObject:)
	@NSManaged public func removeAccident(_ value: Accident)

	@objc(addAccidents:)
	@NSManaged public func addAccidents(_ values: NSSet)

	@objc(removeAccidents:)
	@NSManaged public func removeAccidents(_ values: NSSet)

}

extension Journey: Identifiable {}
