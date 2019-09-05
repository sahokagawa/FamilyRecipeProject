//
//  WriteRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class WriteRecipeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
    
    //料理名テキストフィールド
    @IBOutlet weak var recipeName: UITextField!
    //料理の写真
    @IBOutlet weak var buttonImage: UIButton!
    //メッセージ
    @IBOutlet weak var message: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group

    }
    
    //料理の写真選択ボタン
    @IBAction func selectRecipeImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present (imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            buttonImage.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //レシピ作成ボタンが押されたら
    @IBAction func createRecipe(_ sender: UIButton) {
        let data = buttonImage.imageView?.image?.jpegData(compressionQuality: 0.1)
        let name = recipeName.text
        let messageFor = message.text
        let db = Firestore.firestore()
        db.collection("groups").document(group!.uid).collection("recipes").addDocument(data: [
            "name": name as Any,
            "message": messageFor as Any,
            "photoData": data as Any
            ])
    }
    
    
    

}