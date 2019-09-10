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
    
//    @IBOutlet weak var loginUserLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var groups : [Group] = [] {
        didSet{
            print("--------------------------------")
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gohan.png")!)
        
        //コレクションのレイアウト 余白
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        layout.itemSize = CGSize(width:180, height:180)
        collectionView.collectionViewLayout = layout
        
    
        
        //ログインしているユーザーの情報を取得
         let user = Auth.auth().currentUser!
        //メ-ルアドレスがラベルに表示される
        //loginUserLabel.text = user.email
        //let db = Firestore.firestore()
        //let userName = db.collection("users").document("name")
        //print(user.displayName)
        
//        loginUserLabel.text = user.displayName! + "のマイページ"
        self.navigationItem.title = user.displayName! + "のマイページ"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.000, green: 0.957, blue: 0.747, alpha: 1)
//        let settingImage = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: nil)
//        self.navigationItem.rightBarButtonItem = settingImage
        
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
        
                        let group = Group(uid: document.documentID,
                            name: groupName,
                            photoData: groupImage)
                        groups.append(group)
                    }
                })
                
            }
            
        }
    }
    
    
    
    //セッティングボタンが押されたら
    @IBAction func settingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    
  
    
    //アカウント削除ボタン
//    @IBAction func deleteUserButton(_ sender: UIButton) {
//
//        //アラート
//        let alert =  UIAlertController(title: "アカウントを削除しますか", message: "選択してください", preferredStyle:.alert)
//        let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
//            let user = Auth.auth().currentUser
//            user?.delete { error in
//                if let error = error {
//                    print("エラー")
//                } else {
//                    self.performSegue(withIdentifier: "toBackSignIn", sender: nil)
//                    self.navigationController?.setNavigationBarHidden(true, animated: true)
//                }
//            }
//           print("削除")
//        }
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
//        }
//        alert.addAction(yesAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated:true , completion: nil)
//
//    }
    
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1 //グループの配列＋1 で追加ボタンが表示されるように
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        
        //collectionViewに表示される画像
        let imageView = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
            imageView.image = UIImage(named: "plus")
        } else {
            let group = groups[indexPath.row - 1]
            imageView.image = UIImage(data: group.photoData)
        }
        
        //collectionViewに表示されるテキスト
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            
            label.text = "グループを作成する"
        }else{
            let group = groups[indexPath.row - 1]
            label.text = group.name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toChooseMember", sender: nil)
        } else {
            let group = groups[indexPath.row - 1]
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
            appDelegate.group = group
            performSegue(withIdentifier: "toMyGroup", sender: nil)//group)
        }
        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toMyGroup" {
//            let tabVc = self.presentedViewController as! UITabBarController
//            let nav = tabVc.selectedViewController as! UINavigationController
//            let nextVC = nav.topViewController as! MyGroupViewController
//            nextVC.group = sender as! Group
//        }
//    }
//
}
