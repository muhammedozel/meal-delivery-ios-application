//
//  SignInViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-05-31.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {

    let userDb = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInAction(_ sender: UIButton) {
        
        let email = emailTxtField.text!
        let pwd = pwdTxtField.text!
        
        let request : NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, pwd)
        do {
           let results = try userDb.fetch(request)
            if results.count == 0 {
                print("no results found")
                let alertBox = UIAlertController(title: "Inavlid Login!", message: "Please enter valid Email/Password", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            } else {
                defaults.set(email, forKey: "email")
                defaults.set(pwd, forKey: "password")
                defaults.set(results[0].phone_number!, forKey: "phone_number")
                defaults.set(results[0].profile_photo!, forKey: "profile_photo")
                performSegue(withIdentifier: "homeView", sender: self)
            }
        } catch {
            print("Error!")
        }
    }
}

