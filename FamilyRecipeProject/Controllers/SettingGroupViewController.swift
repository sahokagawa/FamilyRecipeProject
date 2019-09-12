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
    
    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
  
    
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "グループの設定"
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 10
        
        //前のページから渡ってきた、メンバーを表示したい
        collectionView.delegate = self
        collectionView.dataSource = self

         let user = Auth.auth().currentUser
        
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
        
        if group == nil {
            // 選択された人グループに自分を追加
            let me :User = User(uid: user!.uid, name: (user?.displayName)!, photoUrl: (user?.photoURL!.absoluteString)!, groups: [""])
            self.selectedMember.append(me)
        } else{
            buttonImage.setImage(UIImage(data: group!.photoData), for: .normal)
            groupName.text = group?.name
        }
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
            buttonImage.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //グループ作成ボタンが押されたら
    @IBAction func createGroup(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let data = buttonImage.imageView?.image?.jpegData(compressionQuality: 0.1)
        let db = Firestore.firestore()
        
        if group == nil {
        
        var ref: DocumentReference? = nil
        ref = db.collection("groups").addDocument(data: [
            "groupName": groupName.text as Any,
            "photoData": data as Any,
        ]) { err in
            
            if let err = err {
                print("エラーです")
            }else{
                print("成功です")
                //グループ作成成功アラート
                let alert: UIAlertController = UIAlertController(title:"グループを作成しました" , message: "マイページに戻る", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    //マイページに戻りたい
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "myPage") as! UINavigationController
                    
                    self.present(secondViewController, animated: true, completion: nil)
                }
                alert.addAction(yesAction)
                self.present(alert, animated:true , completion: nil)
                
                
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
            
        }else{
            db.collection("groups").document(group!.uid).setData([
                "groupName": groupName.text as Any,
                "photoData": data as Any,
            ])
            
            db.collection("groups").document(group!.uid).collection("users").getDocuments { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                for document in documents {
                    db.collection("groups").document(self.group!.uid).collection("users").document(document.documentID).delete()
                }
                
                
                //選択された人をグループに登録
                for user in self.selectedMember {
                    db.collection("groups").document(self.group!.uid).collection("users").addDocument(data: [
                        "uid": user.uid
                        ])
                    
                    
                    db.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments(completion: { (querySnapshot, error) in
                        
                        guard let documents = querySnapshot?.documents else {
                            return
                        }
                        
                        for document in documents {
                        
                            db.collection("users").document(document.documentID).collection("groups").whereField("groupdId", isEqualTo: self.group?.uid).getDocuments(completion: { (querySnapshot, error) in
                                
                                guard let documents = querySnapshot?.documents else {
                                    return
                                }
                                
                                if documents.count  == 0 {
                                    db.collection("users").document(document.documentID).collection("groups").addDocument(data: [
                                        "groupId": self.group!.uid
                                        ])
                                }
                                
                            })
                            
                            
                        }
                        
                        
                        
                        let alert: UIAlertController = UIAlertController(title:"グループを作成しました" , message: "マイページに戻る", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                            //マイページに戻りたい
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "myPage") as! UINavigationController
                            
                            self.present(secondViewController, animated: true, completion: nil)
                        }
                        alert.addAction(yesAction)
                        self.present(alert, animated:true , completion: nil)
                        
                        
                    })
                }
                
            }
            
            
        }
            
            
//            db.collection("groups").document(group!.uid).collection("users").setD
    
    }
    
    
}
    

extension SettingGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMember.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        let userName = selectedMember[indexPath.row]

        imageView.af_setImage(
            withURL: URL(string: userName.photoUrl)!,
            placeholderImage: UIImage(named: "Placeholder")!,
            imageTransition: .curlUp(0.2))
        label.text = userName.name
        return cell
    }

    
}
