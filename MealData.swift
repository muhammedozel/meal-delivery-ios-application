//
//  MealData.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import Foundation
struct MealData:Codable {
    var name: String = ""
    var detail: String = ""
    var price: Double = 0
    var photo: String = ""
    var calorie_count: Double = 0
    
    init() {}
}
