//
//  OrderHistoryViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-02.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import CoreData

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {

    var orders:[Order] = []
    @IBOutlet weak var orderHistoryTable: UITableView!
    let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderHistoryTable.delegate = self
        self.orderHistoryTable.dataSource = self
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "OrderHistory") as! OrderHistoryTableViewCell
        let order = orders[indexPath.row]
        cell.setOrder(o: order)

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.orderHistoryTable.reloadData()
    }
    
    func getData(){
        let request:NSFetchRequest<Order> = Order.fetchRequest()
        let userEmail = defaults.value(forKey: "email") as? String
        request.predicate = NSPredicate(format: "user.email = %@", userEmail!)
        do {
            let results = try db.fetch(request)

            if results.count == 0 {
                print("no results found")
            }
            else {
                orders = results
            }
        }
        catch {
            print("Error!")
        }
    }
}
