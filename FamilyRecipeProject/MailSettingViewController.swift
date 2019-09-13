//
//  MailSettingViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/13.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class MailSettingViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.title = "メールアドレスの変更"
        mailText.delegate = self
    }
    
    
    @IBAction func sendMail(_ sender: UIButton) {
        if mailText.text != "" {
            let user = Auth.auth().currentUser!
            user.updateEmail(to: mailText.text!) { (error) in
                print(error?.localizedDescription)
            }
        }
        
        //登録確認アラート
        self.alert(title: "確認", message: "ご登録メールアドレスにメールを送信しました", actiontitle: "OK")
        
        
        //登録メアドに確認のメールを送る
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            //エラー処理
            if error != nil {
                let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "main")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
            } else {
                
            }
        })
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   

}
