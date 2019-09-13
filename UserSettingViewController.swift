//
//  UserSettingViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/13.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var imageView: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "プロフィールの変更"
        
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
            imageView.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //変更ボタンが押されたら
    @IBAction func changeButton(_ sender: UIButton) {
        
    }
    
    
}
