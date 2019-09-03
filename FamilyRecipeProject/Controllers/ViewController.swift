//
//  ViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/27.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var loginUserLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var groups : [Group] = [] {
        didSet{
            print("--------------------------------")
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ログインしているユーザーの情報を取得
         let user = Auth.auth().currentUser!
        //メ-ルアドレスがラベルに表示される
        //loginUserLabel.text = user.email
        //let db = Firestore.firestore()
        //let userName = db.collection("users").document("name")
        //print(user.displayName)
        loginUserLabel.text = user.displayName
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //作ったグループをcollectionViewに表示したい
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("groups").getDocuments { (querySnapshot, error) in
            guard let documents  = querySnapshot?.documents else{
                //グループなかった時、処理を中断
                return
            }
            //グループがあった時の処理
            var groups :[Group] = [] {
                didSet {
                    self.groups = groups
                }
            }
            
            for document in documents {
                let groupId = document.get("groupId") as! String
                db.collection("groups").document(groupId).getDocument(completion: { (documentSnapshot, error) in
                    if let document = documentSnapshot, documentSnapshot!.exists {
                        let groupName = document.get("groupName") as! String
                        let groupImage = document.get("photoData") as! Data
        
                        let group = Group(uid: document.documentID, name: groupName, photoData: groupImage)
                        groups.append(group)
                    }
                })
                
            }
            
        }
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1 //グループの配列＋1 で追加ボタンが表示されるように
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        //collectionViewに表示される画像
        let button = cell.viewWithTag(1) as! UIButton
        if indexPath.row == 0 {
            button.setImage(UIImage(named: "4"), for: .normal)
            button.addTarget(self, action: #selector(goToChooseMember(_:)), for: UIControl.Event.touchUpInside)
        } else {
            let group = groups[indexPath.row - 1]
            button.addTarget(self, action: #selector(goToMyGroup(_:)), for: UIControl.Event.touchUpInside)
            button.setImage(UIImage(data: group.photoData), for: .normal)
        }
        
        //collectionViewに表示されるテキスト
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            
            label.text = "追加"
        }else{
            let group = groups[indexPath.row - 1]
            label.text = group.name
        }
        
        return cell
    }
    
    @objc func goToChooseMember (_ sender: UIButton) {
        performSegue(withIdentifier: "toChooseMember", sender: nil)
    }
    
    @objc func goToMyGroup (_ sender: UIButton) {
        performSegue(withIdentifier: "toMyGroup", sender: nil)
    }
    

}
