//
//  SettingTableViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/10.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase


class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changeUser: UILabel!
    @IBOutlet weak var delete: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "設定・その他"

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // 「設定」のセクション
            return 4
        case 1:
            return 1
        default: // ここが実行されることはないはず
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //お問い合わせメール
        if indexPath.section == 1  {
            performSegue(withIdentifier: "toMail", sender: nil)
            
            
        }
        
        
        if   indexPath.section == 0 && indexPath.row == 0 {
            //ログアウトボタンが押されたら
            print(indexPath.section)
            //アラート
            let alert =  UIAlertController(title: "ログアウトしますか？", message: "選択してください", preferredStyle:.alert)
            let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                
            let firebaseAuth = Auth.auth()
                do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "toBackSignIn", sender: nil)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            present(alert, animated:true , completion: nil)
        }
        
        
        //登録情報変更
        if indexPath.row == 1 {
            performSegue(withIdentifier: "toMailSetting", sender: nil)
            }
        
        if indexPath.row == 2 {
            performSegue(withIdentifier: "toUserSetting", sender: nil)
        }
    
        
        
        //アカウント削除ボタン
        if indexPath.row  == 3 {
         //アラート
           let alert =  UIAlertController(title: "アカウントを削除しますか", message: "選択してください", preferredStyle:.alert)
            let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                
            let user = Auth.auth().currentUser
                        user?.delete { error in
                            if let error = error {
                                   print("エラー")
                            } else {
                                self.performSegue(withIdentifier: "toBackSignIn", sender: nil)
                                self.navigationController?.setNavigationBarHidden(true, animated: true)
                                }
                            }
                                    print("削除")
                    }
            
                    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
                    }
                    alert.addAction(yesAction)
                    alert.addAction(cancelAction)
            
                    present(alert, animated:true , completion: nil)
            
                }
        
       
    }
    
    
    
    
    
}

