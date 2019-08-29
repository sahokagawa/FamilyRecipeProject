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
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let button = cell.viewWithTag(1) as! UIButton
        
        button.setImage(UIImage(named: "1"), for: .normal)
        
        if indexPath.row == 0 {
            button.setImage(UIImage(named: "4"), for: .normal)
        }
        
        let label = cell.viewWithTag(2) as! UILabel
        label.text = "登録グループ"
        
        if indexPath.row == 0 {
            label.text = "追加"
        }
        
        
        return cell
    }
    
    
}
