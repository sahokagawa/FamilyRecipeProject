//
//  ChooseMemberViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class ChooseMemberViewController: UIViewController {
    
    

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var SettingButton: UIButton!
    @IBOutlet weak var searchUser: UITextField!
    
    //検索結果
    @IBOutlet weak var resultCollection: UICollectionView!
    //    @IBOutlet weak var resultTable: UITableView!
    var users :[User] = [] {
        didSet {
            resultCollection.reloadData()
        }
    }
    
    
    var documentId = ""
    
    //選択されたユーザー
    @IBOutlet weak var choosenUser: UICollectionView!
    var selectedUsers :[User] = [] {
        didSet {
            choosenUser.reloadData()
        }
    }
    
    
    //設定でグループのメンバー選ぶときにい今現在のメンバーを表示したい
    var group: Group? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       resultTable.dataSource = self
//       resultTable.delegate = self
        choosenUser.delegate = self
        choosenUser.dataSource = self
        resultCollection.delegate = self
        resultCollection.dataSource = self
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gohan.png")!)
        
        
        searchUser.layer.borderWidth = 1
        searchUser.layer.cornerRadius = 10
        SettingButton.layer.borderWidth = 1
        searchButton.layer.borderWidth = 1
        SettingButton.layer.cornerRadius = 10
        searchButton.layer.cornerRadius = 10
        
        
        //ナビゲーション
        self.navigationItem.title = "メンバーを選択"
        
        //設定でグループのメンバー選ぶときにい今現在のメンバーを表示したい
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
        
        if group != nil {
            searchMemberByGroupId(groupId: group!.uid)
        }
        
    }
    
    
    
    //検索ボタンがクリックされたら
    @IBAction func searchButton(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("users").whereField("name", isEqualTo: searchUser.text).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
            //検索結果がないとき
                return
            }
            //検索結果あった時
            var users :[User] = []
            
            for document in documents {
                let uid = document.get("uid") as! String
                let name = document.get("name") as! String
                let photoUrl = document.get("photo") as! String
                let groups = [""]
                //インスタンス化
                let user = User(uid: uid, name: name, photoUrl: photoUrl, groups: groups)
                users.append(user)
            }
            
            print(users)
        //19行目あたりのuserと検索結果あった時のuserは違うものだから、同じにする
            self.users = users
            
        }
    }
    
    
    
    // グループメンバーを選んで次のページに行く時
    @IBAction func toSettingGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettingGroup", sender: selectedUsers)
    }
    //次のページに選ばれたメンバーの情報を渡したい
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingGroup"{
            let nextVC = segue.destination as! SettingGroupViewController
            nextVC.selectedMember = sender as! [User]
        }
        
    }
    
}




extension ChooseMemberViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.resultCollection {
            return users.count
        }
        if collectionView == self.choosenUser {
            return selectedUsers.count
        }else{
            return 0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //検索結果コレクション
        if collectionView == self.resultCollection {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            let userName2 = users[indexPath.row]
            let imageView2 = cell2.viewWithTag(1) as! UIImageView
            imageView2.af_setImage(withURL: URL(string: userName2.photoUrl)!,placeholderImage: UIImage(named: "Placeholder")!,imageTransition: .curlUp(0.2)
            )
            let label2 = cell2.viewWithTag(2) as! UILabel
            label2.text = userName2.name
            return cell2
        }
        
        //選択されたユーザーコレクション
        if collectionView == self.choosenUser {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let userName = selectedUsers[indexPath.row]
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.af_setImage(
                withURL: URL(string: userName.photoUrl)!,
                placeholderImage: UIImage(named: "Placeholder")!,
                imageTransition: .curlUp(0.2))
            let label = cell.viewWithTag(2) as! UILabel
            label.text = userName.name
            
            //メンバーを削除したい
            let deleteButton = cell.viewWithTag(3) as! UIButton
            deleteButton.layer.setValue(indexPath.row, forKey: "index")
            deleteButton.addTarget(self, action: #selector(deleteUser(_:)), for: UIControl.Event.touchUpInside)

            return cell
        }else{
            return UICollectionViewCell()
        }
        
    
    }

    //セルがクリックされたら
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.resultCollection{
            selectedUsers.append(users[indexPath.row])
        }
        print(selectedUsers)
    }
    
    //セル削除したい
    @objc func deleteUser(_ sender: UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        selectedUsers.remove(at: i)
        choosenUser.reloadData()
    }
    
    
    func searchMemberByGroupId(groupId:String){
        
        let db = Firestore.firestore()
        
        db.collection("groups").document(groupId).collection("users").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            var groupId :[String] = []
            for document in documents {
                let uid = document.get("uid") as! String
                groupId.append(uid)
            }
            
            self.selectedUsers = []
            for id in groupId {
                db.collection("users").document(id).getDocument(completion: { (documentSnapshot, error) in
                    let userName = documentSnapshot?.get("name") as! String
                    let groupImage = documentSnapshot?.get("photo") as! String
                    let groups = [""]
                    
                    let user = User(uid: id, name: userName, photoUrl: groupImage, groups: groups)
                    self.selectedUsers.append(user)
                })

            }
            
            
        }
        
        
    }
}
