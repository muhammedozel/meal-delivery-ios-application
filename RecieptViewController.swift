//
//  RecieptViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit

class RecieptViewController: UIViewController {

    @IBOutlet weak var nameOfMealLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    var mealName:String?
    var sku:String?
    var subtotal:String?
    var taxes:String?
    var total:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameOfMealLabel.text = mealName
        totalLabel.text = total
        taxesLabel.text = taxes
        subtotalLabel.text = subtotal
        skuLabel.text = sku
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
