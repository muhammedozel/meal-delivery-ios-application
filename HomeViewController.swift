//
//  HomeViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mealData:[MealData] = []
    var meals:[Meal] = []
    let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var shakeMotionCount:Int = 0
    @IBOutlet weak var mealTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealTableView.delegate = self
        self.mealTableView.dataSource = self
        if(defaults.object(forKey: "read_from_json") != nil){
            //read From Database
        } else {
            print("read from json")
            defaults.setValue(true, forKey: "read_from_json")
            let file = openFile()
            mealData = self.getData(from: file)!
            for m in mealData {
                let meal = Meal(context: db)
                meal.name = m.name
                meal.detail = m.detail
                meal.calorie_count = m.calorie_count
                meal.photo = m.photo
                meal.price = m.price
                do {
                    try db.save()
                }
                catch {
                    print("error!")
                }
            }
        }
        let request:NSFetchRequest<Meal> = Meal.fetchRequest()
        do {
            let results = try db.fetch(request)

            if results.count == 0 {
                print("no results found")
            }
            else {
                meals = results
            }
        }
        catch {
            print("Error!")
        }
    }
    
    func openFile() -> String? {
        guard let file = Bundle.main.path(forResource:"Meals", ofType:"json") else {
            print("Cannot find file")
            return nil;
        }
        print("File found: \(file.description)")

        return file
    }
    
    func getData(from file:String?) -> [MealData]? {
        if (file == nil) {
            print("File path is null")
            return nil
        }
        do {
            let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
            let decodedData = try JSONDecoder().decode([MealData].self, from: jsonData!)
            
            return decodedData
        } catch {
            print("Error while parsing file")
            print(error.localizedDescription)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell") as! MealTableViewCell
        let meal = meals[indexPath.row]
        cell.setMeal(m: meal)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = mealTableView.indexPath(for: sender as! MealTableViewCell)
        let mealDetail = segue.destination as? MealDetailViewController
        mealDetail?.mealDetails = meals[selectedIndex!.row]
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        shakeMotionCount += 1
        var couponPercentage:Int = 0
        var saveCoupon = false
        if(shakeMotionCount == 3) {
            shakeMotionCount = 0
            let chance = Int.random(in: 1...100);
            if (chance <= 30) {
                //30% Chance of 10% coupon
                couponPercentage = 10
                saveCoupon = true
                let couponCode = couponCodeGenerator(length: 6)
                let alertBox = UIAlertController(title: "\(couponCode)", message: "Congrats! You won 10% coupon", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            } else if (chance <= 35) {
                //5% Chance of 50% coupon
                let couponCode = couponCodeGenerator(length: 6)
                let alertBox = UIAlertController(title: "\(couponCode)", message: "Congrats! You won 50% coupon", preferredStyle: .alert)
                               alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                               self.present(alertBox, animated: true, completion: nil)
                couponPercentage = 50
                saveCoupon = true
            } else {
                //0% Chance
                let alertBox = UIAlertController(title: "Unlucky!", message: "Sorry! Come back tomorrow...", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
                couponPercentage = 0
                saveCoupon = false
            }
            if(saveCoupon){
                let coupon = Coupon(context: db)
                let email = defaults.value(forKey: "email") as? String
                let user = User(context: db)
                user.email = email
                coupon.is_valid = true
                coupon.name = couponCodeGenerator(length: 6)
                coupon.coupon_percentage = Int16(couponPercentage)
                coupon.user = user
                do {
                    try db.save()
                }
                catch {
                    print("error!")
                }
            }
            
        }
    }

    func couponCodeGenerator(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
