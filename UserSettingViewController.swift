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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "プロフィールの変更"
        nameText.delegate = self
        let user = Auth.auth().currentUser!
        let db = Firestore.firestore()
        
        nameText.text = user.displayName
        
        print(user.photoURL!)

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: user.photoURL!)
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.imageViewButton.setImage(image, for: .normal)
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
            present (imagePicker, animated: true, completion: nil)
        }
    }
    
    //選択した画像を画面に表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            imageViewButton.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //変更ボタンが押されたら
    @IBAction func changeButton(_ sender: UIButton) {
        if nameText.text != "" {
            
        }
    }
    
    
}
