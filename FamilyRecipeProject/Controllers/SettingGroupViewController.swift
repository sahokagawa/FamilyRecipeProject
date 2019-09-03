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
    

    //グループ画像選択
    @IBAction func selectGroupImage(_ sender: UIButton) {
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
    
    
    
    
    //グループ作成ボタンが押されたら
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
                
                // 選択された人グループに自分を追加
                let me :User = User(uid: user!.uid, name: (user?.displayName)!, photoUrl: (user?.photoURL!.absoluteString)!, groups: [""])
                self.selectedMember.append(me)
                
                //選択された人をグループに登録
                for user in self.selectedMember {
                    ref?.collection("users").addDocument(data: [
                        "uid": user.uid
                    ])
                    
                    db.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments(completion: { (querySnapshot, error) in
                        
                        guard let documents = querySnapshot?.documents else {
                            return
                        }
                        
                        for document in documents {
                            db.collection("users").document(document.documentID).collection("groups").addDocument(data: [
                                "groupId": ref!.documentID
                            ])
                        }
                        
                    })
                }
                
                
            }
            
        }
    }
    
}
    

