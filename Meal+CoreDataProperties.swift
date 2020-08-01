//
//  Meal+CoreDataProperties.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-05-31.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var name: String?
    @NSManaged public var detail: String?
    @NSManaged public var price: Double
    @NSManaged public var photo: String?
    @NSManaged public var calorie_count: Double
    @NSManaged public var orders: Order?

}
