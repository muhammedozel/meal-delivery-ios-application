//
//  Coupon+CoreDataProperties.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-05-31.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//
//

import Foundation
import CoreData


extension Coupon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coupon> {
        return NSFetchRequest<Coupon>(entityName: "Coupon")
    }

    @NSManaged public var name: String?
    @NSManaged public var is_valid: Bool
    @NSManaged public var coupon_percentage: Int16
    @NSManaged public var user: User?
}
