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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ログインしているユーザーの情報を取得
         let user = Auth.auth().currentUser!
            //メ-ルアドレスがラベルに表示される
//        loginUserLabel.text = user.email
        
        let db = Firestore.firestore()
        let userName = db.collection("users").document("name")
        print(user.displayName)
        loginUserLabel.text = user.displayName
        
        
    }


}

