//
//  MealTableViewCell.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMeal(m:Meal){
        mealNameLabel.text = m.name
        mealImageView.image = UIImage(named: ((m.photo!.trimmingCharacters(in: .whitespacesAndNewlines) != "" ? m.photo : "default")!))
        mealPriceLabel.text = String("$\(m.price)")
    }

}
