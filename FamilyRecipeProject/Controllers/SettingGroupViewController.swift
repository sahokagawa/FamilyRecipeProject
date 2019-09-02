//
//  SettingGroupViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class SettingGroupViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //前の画面から選ばれたユーザーを受け取るための変数
    var selectedMember :[User] = []
  
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    @IBAction func selectGroupImage(_ sender: UIButton) {
        //グループ画像選択
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
            groupImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //グループ作成ボタン
    @IBAction func createGroup(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let data = groupImage.image?.jpegData(compressionQuality: 0.1)
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("groups").addDocument(data: [
            "groupName": groupName.text,
            "photoData": data,
        ]) { err in
            
            if let err = err {
                print("エラーです")
            }else{
                print("成功です")
                
                
                for user in self.selectedMember {
                    ref?.collection("users").addDocument(data: [
                        "uid": user.uid
                    ])
                }
                
                
            }
            
        }
    }
    
}
    

