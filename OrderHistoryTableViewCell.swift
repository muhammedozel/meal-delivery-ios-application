//
//  OrderHistoryTableViewCell.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-02.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrder(o:Order){
        nameLabel.text = o.name
        skuLabel.text = o.sku
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL dd, yyyy"
        let date = dateFormatter.string(from: o.date)
        dateLabel.text = date
        totalLabel.text = "$\(String(format: "%.2f",o.total))"
    }

}
