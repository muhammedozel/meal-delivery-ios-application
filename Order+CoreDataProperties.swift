//
//  Order+CoreDataProperties.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-05-31.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var name: String?
    @NSManaged public var sku: String?
    @NSManaged public var subtotal: Double
    @NSManaged public var is_custom_tip: Bool
    @NSManaged public var tip_percentage: Int16
    @NSManaged public var tip_amount: Double
    @NSManaged public var total: Double
    @NSManaged public var status: String?
    @NSManaged public var date: Date
    @NSManaged public var user: User?
    @NSManaged public var meal: Meal?

}
