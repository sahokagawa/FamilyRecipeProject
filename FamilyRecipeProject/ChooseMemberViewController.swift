//
//  ChooseMemberViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class ChooseMemberViewController: UIViewController {
    
    
    @IBOutlet weak var searchUser: UITextField!
    
    
    @IBOutlet weak var resultTable: UITableView!
    var users :[User] = [] {
        didSet {
            resultTable.reloadData()
        }
    }
    
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       resultTable.dataSource = self
       resultTable.delegate = self

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
                //インスタンス化
                let user = User(uid: uid, name: name)
                users.append(user)
            }
            
            print(users)
            //テーブルに表示させんといけん
           
            //19行目あたりのuserと検索結果あった時のuserは違うものだから、同じにする
            self.users = users
            
        }
    }
    
    
    
    // グループメンバーを選んで次のページに行く時
    @IBAction func toSettingGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettingGroup", sender: nil)
    }
    
}



extension ChooseMemberViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userName = users[indexPath.row]
        cell.textLabel?.text = userName.name
        return cell
    }
    
    //セルがクリックされたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let db = Firestore.firestore()
        db.collection("groups").document(documentId).collection("users").addDocument(data: ["uid" :uid as Any])
        
    }

}
