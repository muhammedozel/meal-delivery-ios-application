//
//  AccountViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-06-01.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = defaults.value(forKey: "email") as? String
        phoneLabel.text = defaults.value(forKey: "phone_number") as? String
        let imagePath = defaults.value(forKey: "profile_photo") as? String
        getImage(imageName: imagePath!)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "phone_number")
    }

    func getImage(imageName: String){
       let fileManager = FileManager.default
       let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
       if fileManager.fileExists(atPath: imagePath){
          profileImageView.image = UIImage(contentsOfFile: imagePath)
       } else {
          print("Image Not found!")
       }
    }
}
