//
//  SiginInViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/27.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SiginInViewController: UIViewController, UITextFieldDelegate {

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
    
    @IBAction func remindPassword(_ sender: UIButton) {
        let remindPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        remindPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        remindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
            let resetEmail = remindPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                    } else {
                        self.alert(title: "エラー", message: "このメールアドレスは登録されてません。", actiontitle: "OK")
                    }
                }
            })
        }))
        remindPasswordAlert.addTextField { (textField) in
            textField.placeholder = "test@gmail.com"
        }
        self.present(remindPasswordAlert, animated: true, completion: nil)
    }
    

    @IBAction func siginIn(_ sender: UIButton) {
        //ちゃんと入力されてるかの確認
        if mailForm.text != "" && passForm.text != "" {
            Auth.auth().signIn(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                if error == nil {
                    //ホーム画面へ移行
//                    let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
//                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "toHome")
//                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                } else {
                    self.alert(title: "エラー", message: "メールアドレスまたはパスワードが間違ってます。", actiontitle: "OK")
                }
            }
        } else {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
        }
    }
    
    
    
    @IBAction func backSiginUp(_ sender: UIButton) {
        performSegue(withIdentifier: "toSIginUp", sender: nil)
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailForm.resignFirstResponder()
        passForm.resignFirstResponder()
    }

    
}
