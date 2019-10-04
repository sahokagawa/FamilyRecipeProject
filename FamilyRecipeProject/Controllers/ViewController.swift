//
//  ViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/27.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController {
    
//    @IBOutlet weak var loginUserLabel: UILabel!
    
    //広告
    @IBOutlet weak var bannerView: GADBannerView!
    //テスト用の広告
//    let admobId = "ca-app-pub-3940256099942544/2934735716"
    //リリース用
    let admobId = "ca-app-pub-4775744210161408/2496870902"
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var groups : [Group] = [] {
        didSet{
            print("--------------------------------")
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate.group = nil
        
        //        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gohan.png")!)
        
        
        //広告
        bannerView.adUnitID = admobId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        //コレクションのレイアウト 余白
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        layout.itemSize = CGSize(width:170, height:170)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.settingButton))
        
        
        //        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.000, green: 0.957, blue: 0.747, alpha: 1)
        //        let settingImage = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: nil)
        //        self.navigationItem.rightBarButtonItem = settingImage
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //作ったグループをcollectionViewに表示したい
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("groups").getDocuments { (querySnapshot, error) in
            guard let documents  = querySnapshot?.documents else{
                //グループなかった時、処理を中断
                self.groups = []
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
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count + 1 //グループの配列＋1 で追加ボタンが表示されるように
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
//        cell.layer.borderWidth = 0.5
        
        //collectionViewに表示される画像
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 10
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
    
}
