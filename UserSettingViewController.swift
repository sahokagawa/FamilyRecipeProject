//
//  UserSettingViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/13.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class UserSettingViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var imageViewButton: UIButton!
    
    @IBOutlet weak var changeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "プロフィールの変更"
        nameText.delegate = self
        
        nameText.layer.cornerRadius = 10
        imageViewButton.layer.cornerRadius = 10
        changeButton.layer.cornerRadius = 10
        
        
        let user = Auth.auth().currentUser!
        let db = Firestore.firestore()
        
        nameText.text = user.displayName
        
        print(user.photoURL!)

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: user.photoURL!)
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
//                    self.imageViewButton.setImage(image, for: .normal)
                    self.imageViewButton.setBackgroundImage(image, for: .normal)
                    self.imageViewButton.setTitle("タップして画像を選択", for:.normal)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @IBAction func imageView(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present (imagePicker, animated: true, completion: nil)
        }
    }
    
    //選択した画像を画面に表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] != nil {
            let image = info[.editedImage] as! UIImage
            imageViewButton.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //変更ボタンが押されたら
    @IBAction func changeButton(_ sender: UIButton) {
        if nameText.text != "" {
            let user = Auth.auth().currentUser!
            
            let userName = nameText.text
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = userName
            changeRequest?.commitChanges { (error) in
                // ...
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).updateData(["name": userName as Any]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    //登録確認アラート
                    self.alert(title: "確認", message: "変更しました", actiontitle: "OK")
                }
            }
            
            
            var profileImage: Data!
            if let imageUrl = self.imageViewButton.imageView?.image{
                profileImage = imageUrl.jpegData(compressionQuality: 0.1)! as! Data
            }else{
                profileImage = UIImage(named: "gohan")?.jpegData(compressionQuality: 0.1)!
            }
            
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let riversRef = storageRef.child("profiles/\(user.uid).jpg")
            let uploadTask = riversRef.putData(profileImage, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                let size = metadata.size
                // You can also access to download URL after upload.
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    let changeRequest2 = user.createProfileChangeRequest()
                    changeRequest2.photoURL = downloadURL
                    changeRequest2.commitChanges(completion: { (error)in
                        
                    })
                    
                    db.collection("users").document(user.uid).updateData(["photo":downloadURL.absoluteString]){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            
            }
            
            uploadTask.resume()
        }
    }
    
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
