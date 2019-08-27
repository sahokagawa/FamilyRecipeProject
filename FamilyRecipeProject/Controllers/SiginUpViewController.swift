//
//  SiginUpViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/27.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class SiginUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UITextFieldのデリゲート
        mailForm.delegate = self
        passForm.delegate = self
        
        //UITextFieldに枠線,角丸を施す
        mailForm.layer.borderWidth = 1
        mailForm.layer.cornerRadius = 10
        passForm.layer.borderWidth = 1
        passForm.layer.cornerRadius = 10
        
    }
    
    @IBAction func siginUp(_ sender: UIButton) {
        //２つのフォームが入力されてる場合
        if mailForm.text != "" && passForm.text != "" {
            //入力したパスワードが7文字以上の場合
            if (passForm.text?.count)! > 6  {
                //会員登録開始
                Auth.auth().createUser(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                    //ログイン成功
                    if error == nil {
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
                        //ログイン失敗
                    } else {
                        self.alert(title: "エラー", message: "ログイン失敗", actiontitle: "OK")
                    }
                }
                //入力したパスワードが6文字以下の場合
            } else {
                self.alert(title: "エラー", message: "7文字以上のパスワードを入力してください。", actiontitle: "OK")
            }
            //いずれかのフォームが未入力の場合
        } else {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
        }
    }
    
    
    @IBAction func siginIn(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Returnでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面外タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailForm.resignFirstResponder()
        passForm.resignFirstResponder()
    }
    

}
