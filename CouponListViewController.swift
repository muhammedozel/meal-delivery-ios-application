//
//  CouponListViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-03.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import CoreData

class CouponListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coupons:[Coupon] = []
    let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell")!
        let coupon = coupons[indexPath.row]
        cell.textLabel?.text = coupon.name! + " - " + String(coupon.coupon_percentage) + "%"
        cell.detailTextLabel?.text = coupon.is_valid ? "Active" : "Inactive"

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        self.tableView.reloadData()
    }
    
    func getData(){
        let request:NSFetchRequest<Coupon> = Coupon.fetchRequest()
        let userEmail = defaults.value(forKey: "email") as? String
        request.predicate = NSPredicate(format: "user.email = %@", userEmail!)
        request.sortDescriptors = [NSSortDescriptor(key: "is_valid", ascending: false)]
        do {
            let results = try db.fetch(request)

            if results.count == 0 {
                print("no results found")
            }
            else {
                coupons = results
            }
        }
        catch {
            print("Error!")
        }
    }
}
