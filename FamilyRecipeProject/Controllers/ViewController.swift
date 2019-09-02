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
        let groupName = db.collection("groups").document("groupName")
        let groupImage = db.collection("groups").document("photoData")
        
        let group = Group(name: groupName, photoData: groupImage)
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        let groupName =
        
        let button = cell.viewWithTag(1) as! UIButton
        if indexPath.row == 0 {
            button.setImage(UIImage(named: "4"), for: .normal)
            button.addTarget(self, action: #selector(goToChooseMember(_:)), for: UIControl.Event.touchUpInside)
        } else {
            button.addTarget(self, action: #selector(goToMyGroup(_:)), for: UIControl.Event.touchUpInside)
            button.setImage(UIImage(named: "photoData"), for: .normal)
        }
        
        
        
        let label = cell.viewWithTag(2) as! UILabel
//        label.text =
        
        if indexPath.row == 0 {
            
            label.text = "追加"
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
