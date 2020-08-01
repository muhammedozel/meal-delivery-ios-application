//
//  MealDetailViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import CoreData

class MealDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var couponAmountLabel: UILabel!
    @IBOutlet weak var couponLabel: UITextField!
    var sku:String?
    var tipPercentage:Int = 10
    var isCustomTip:Bool = false
    var mealDetails: Meal?
    var totalAmount:Double?
    var tipAmount:Double?
    var userActiveCoupons:[String] = []
    var couponsWithPercentage:[String:Int] = [:]
    var couponAmount:Double = 0
    
    
    let orderDb = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponLabel.autocapitalizationType = .allCharacters
        nameLabel.text = mealDetails!.name
        calorieLabel.text = String("\(mealDetails!.calorie_count) Cals")
        detailLabel.text = mealDetails!.detail
        subtotalLabel.text = String("$\(mealDetails!.price)")
        taxesLabel.text = String("$\(mealDetails!.price * 0.13)")
        tipAmount = mealDetails!.price * 0.10
        tipLabel.text = String("$\(tipAmount!)")
        let total:Double = getTotal(price: mealDetails!.price, tip: tipAmount!)
        totalAmount = total
        totalLabel.text = "$\(String(format: "%.2f", total))"
        imageView.image = UIImage(named: ((mealDetails!.photo!.trimmingCharacters(in: .whitespacesAndNewlines) != "" ? mealDetails!.photo : "default")!))

        let request:NSFetchRequest<Coupon
            > = Coupon.fetchRequest()
        let userEmail = defaults.value(forKey: "email") as? String
        request.predicate = NSPredicate(format: "user.email = %@ AND is_valid = 1", userEmail!)
        do {
            let results = try orderDb.fetch(request)

            if results.count == 0 {
                print("no results found")
            }
            else {
                for res in results {
                    userActiveCoupons.append(res.name!)
                    couponsWithPercentage[res.name!] = Int(res.coupon_percentage)
                }
            }
        }
        catch {
            print("Error!")
        }
        
    }
    
    func getTotal(price:Double, tip:Double) -> Double {
        return price + tip + (price * 0.13) + couponAmount
    }
    
    @IBAction func segmentChangeAction(_ sender: UISegmentedControl) {
        var total:Double = 0
        switch sender.selectedSegmentIndex {
            case 0:
                tipAmount = mealDetails!.price * 0.10
                self.tipLabel.text = "$\(String(format: "%.2f", tipAmount!))"
                total = getTotal(price: mealDetails!.price, tip: tipAmount!)
                totalLabel.text = "\(String(format: "%.2f", total))"
                tipPercentage = 10
                isCustomTip = false
                totalAmount = total
            case 1:
                tipAmount = mealDetails!.price * 0.15
                self.tipLabel.text = "$\(String(format: "%.2f", tipAmount!))"
                total = getTotal(price: mealDetails!.price, tip: tipAmount!)
                totalLabel.text = "\(String(format: "%.2f", total))"
                tipPercentage = 15
                isCustomTip = false
                totalAmount = total
            case 2:
                tipAmount = mealDetails!.price * 0.20
                self.tipLabel.text = "$\(String(format: "%.2f", tipAmount!))"
                total = getTotal(price: mealDetails!.price, tip: tipAmount!)
                totalLabel.text = "\(String(format: "%.2f", total))"
                tipPercentage = 20
                isCustomTip = false
                totalAmount = total
            case 3:
                let alertBox = UIAlertController(title: "Custom Tip", message: "Enter tip amount", preferredStyle: .alert)
                alertBox.addTextField { (textField) in
                    textField.text = String(0)
                    textField.keyboardType = .numberPad
                }
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertBox] (_) in
                    let textField = alertBox!.textFields![0]
                    self.tipAmount = Double(textField.text!)!
                    self.tipLabel.text = "$\(String(format: "%.2f", self.tipAmount!))"
                    total = self.getTotal(price: self.mealDetails!.price, tip: self.tipAmount!)
                    self.totalLabel.text = "$\(String(format: "%.2f", total))"
                    self.totalAmount = total
                }))
                self.present(alertBox, animated: true, completion: nil)
                tipPercentage = 0
                isCustomTip = true
            default:
                print("default")
        }
    }
    
    @IBAction func placeOrderAction(_ sender: UIButton) {
        sku = skuStringGenerator(length: 8)
        let user = User(context: orderDb)
        user.email = defaults.value(forKey: "email") as? String
        let order = Order(context: orderDb)
        order.name = nameLabel.text
        order.sku = sku
        order.status = "Active"
        order.user = user
        order.subtotal = mealDetails!.price
        order.tip_amount = tipAmount!
        order.tip_percentage = Int16(tipPercentage)
        order.is_custom_tip = isCustomTip
        order.total = totalAmount!
        order.date = Date()
        do {
            try orderDb.save()
        } catch {
            print("An error occurred while saving: \(error)")
        }
        let request:NSFetchRequest<Coupon
            > = Coupon.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", couponLabel.text!)
        do {
            let results = try orderDb.fetch(request)

            if results.count == 0 {
                print("no results found")
            }
            else {
                let cpnObject = results[0]
                cpnObject.setValue(false, forKey: "is_valid")
                do {
                    try orderDb.save()
                } catch {
                    print("An error occurred while saving: \(error)")
                }
            }
        }
        catch {
            print("Error!")
        }
        performSegue(withIdentifier: "receiptView", sender: self)
    }
    
    func skuStringGenerator(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func applyCouponAction(_ sender: UIButton) {
        let coupon = couponLabel.text!
        if(userActiveCoupons.contains(coupon)){
            let couponValue = mealDetails!.price * (Double(couponsWithPercentage[coupon]!)/100.0)
            couponAmount = Double(couponValue)
            let total = getTotal(price: mealDetails!.price, tip: tipAmount!)
            totalLabel.text = "$\(String(format: "%.2f", total))"
            couponAmountLabel.text = "$\(String(format: "%.2f",couponValue))"
        } else {
            let alertBox = UIAlertController(title: "Invalid!", message: "Please enter valid coupon code.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reciept = segue.destination as? RecieptViewController
//        let history = segue.destination as? OrderHistoryViewController
        
        reciept?.mealName = mealDetails?.name
        reciept?.sku = sku!
        reciept?.subtotal = subtotalLabel.text!
        reciept?.total = totalLabel.text!
        reciept?.taxes = taxesLabel.text!
    }
}
