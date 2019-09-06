//
//  WriteTryRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class WriteTryRecipeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
    
    
    @IBOutlet weak var tryRecipeName: UITextField!
    @IBOutlet weak var tryRecipeImage: UIButton!
    @IBOutlet weak var tryRecipeMessage: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group

    }
    
    @IBAction func selectTryRecipeImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present (imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            tryRecipeImage.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    //作ってみた完成ボタン
    @IBAction func createTryRecipe(_ sender: UIButton) {
        let data = tryRecipeImage.imageView?.image?.jpegData(compressionQuality: 0.1)
        let name = tryRecipeName.text
        let messageFor = tryRecipeMessage.text
        let db = Firestore.firestore()
        db.collection("groups").document(group!.uid).collection("tryRecipes").addDocument(data: [
            "name": name as Any,
            "message": messageFor as Any,
            "photoData": data as Any
            ])
        
        
    }
    
    
}
