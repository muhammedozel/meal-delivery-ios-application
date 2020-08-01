//
//  SignupViewController.swift
//  MealDeliveryApp
//
//  Created by Vedang Yagnik on 2020-05-31.
//  Copyright © 2020 Vedang Yagnik. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import CoreData

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var phoneNumTxtField: UITextField!
    var imagePicker:UIImagePickerController!
    var imagePath:String = ""
    
    let userDb = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    

    @IBAction func signupAction(_ sender: UIButton) {
        let user = User(context:userDb)
        user.email = emailTxtField.text!
        user.password = pwdTxtField.text!
        user.phone_number = phoneNumTxtField.text!
        user.profile_photo = imagePath
        var isError = false
        let title = "Error!"
        var message = "Undefined Error!"
        if(user.email!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            isError = true
            message = "Please enter Email"
        } else if (user.password?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            isError = true
            message = "Please enter Password"
        }
        
        if (isError) {
            let alertBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        } else {
            do {
                try userDb.save()
            }
            catch {
                print("error!")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func returnToSignInAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func profileImageTapAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default){ _ in
            self.imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
                print("Camera not available!")
                
                return
            }
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let chooseFromLibAction = UIAlertAction(title: "Choose From Library", style: .default){ _ in
            self.imagePicker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) {
                print("Gallery not found!")
                
                return
            }
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromLibAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let photoTakenFromCamera = info[.originalImage] as? UIImage
        self.profileImageView.image = photoTakenFromCamera
        imagePath = "image_" + String(Date().timeIntervalSince1970)
        saveImage(imageName: imagePath)
    }

    func saveImage(imageName: String){
       let fileManager = FileManager.default
       let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = self.profileImageView.image!
        let data = image.jpegData(compressionQuality: 1.0)
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
}

