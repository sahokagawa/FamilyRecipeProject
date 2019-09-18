//
//  AllMemberViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/17.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
class AllMemberViewController: UIViewController {

    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
    
    var member :[User] = [] {
        didSet{
            MemberTableView.reloadData()
        }
    }
    
    @IBOutlet weak var MemberTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MemberTableView.delegate = self
        MemberTableView.dataSource = self
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group

        self.navigationItem.title = "メンバー"
    
        let db = Firestore.firestore()
        db.collection("groups").document(group!.uid).collection("users").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            var member :[User] = [] {
                didSet {
                    self.member = member
                }
            }
            for document in documents {
                let uid = document.get("uid")
                db.collection("users").document(uid as! String).getDocument(completion: { (document, error) in
                    let name = document?.get("name")
                    let photo = document?.get("photo")
                    let user = User(uid: uid as! String, name: name as! String, photoUrl: photo as! String, groups: [])
                    member.append(user)
                })
            }
            
            
        }
        
        
    }
    

 

}


extension AllMemberViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return member.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.af_setImage(withURL: URL(string: member[indexPath.row].photoUrl)!,placeholderImage: UIImage(named: "Placeholder")!,imageTransition: .curlUp(0.2)
        )
        let label = cell.viewWithTag(2) as! UILabel
        label.text = member[indexPath.row].name
        return cell
    }

//セルがクリックされたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "アカウント", message: "選択してください", preferredStyle: .actionSheet)
        let block = UIAlertAction(title: "ブロックする", style: .default) { (UIAlertAction) in
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            db.collection("users").document(self.member[indexPath.row].uid).collection("blocks").document(user!.uid).setData(["uid": user?.uid])
        }
        
        let report = UIAlertAction(title: "通報する", style: .default) { (UIAlertAction) in
            
//            //確認したい
//            let alert2 = UIAlertController(title: "選択ユーザーをブロックしますか？", message: "相手ユーザー検索結果に表示されなくなります", preferredStyle: .alert)
//
//           let yerAction =UIAlertAction
//            let noAction = UIAlertAction
            
            let db = Firestore.firestore()
        db.collection("report").document("user").collection("users").document(self.member[indexPath.row].uid).setData([
                "uid": self.member[indexPath.row].uid])
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .default) { (UIAlertAction) in
            
        }
        
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancel)
        present(alert, animated:true , completion: nil)
    }

}


