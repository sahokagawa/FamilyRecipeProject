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
    @IBOutlet weak var clickButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tryRecipeImage.setTitle("タップして画像を選択", for: .normal)
        tryRecipeImage.setBackgroundImage(UIImage(named: "gohan"), for: .normal)
        self.navigationItem.title = "作ってみたを書く"
        tryRecipeMessage.layer.cornerRadius = 10
        clickButton.layer.cornerRadius = 10
        tryRecipeImage.layer.cornerRadius = 10
        
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
    }
    
    @IBAction func selectTryRecipeImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present (imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] != nil {
            let image = info[.editedImage] as! UIImage
            tryRecipeImage.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    //作ってみた完成ボタン
    @IBAction func createTryRecipe(_ sender: UIButton) {
        var tryrecipeImage: Data!
        if let data = tryRecipeImage.imageView?.image{
            tryrecipeImage = data.jpegData(compressionQuality: 0.1)!
        }else{
            tryrecipeImage = UIImage(named: "gohan")?.jpegData(compressionQuality: 0.1)!
        }
        let name = tryRecipeName.text
        let messageFor = tryRecipeMessage.text
        let db = Firestore.firestore()
        db.collection("groups").document(group!.uid).collection("tryRecipes").addDocument(data: [
            "name": name as Any,
            "message": messageFor as Any,
            "photoData": tryrecipeImage
        ]) { err in
            
            if let err = err {
                print("エラーです")
            }else{
                print("成功です")
                //グループ作成成功アラート
                let alert: UIAlertController = UIAlertController(title:"作ってみたを作成しました" , message: "グループに戻る", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
//                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupPage") as! UITabBarController
//                    self.present(secondViewController, animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yesAction)
                self.present(alert, animated:true , completion: nil)
            }
        }
        
        
    }
    
    
}
