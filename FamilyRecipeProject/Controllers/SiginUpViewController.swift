//
//  SiginUpViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/27.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

class SiginUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var nameForm: UITextField!
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    @IBOutlet weak var siginUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    
    
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //スクロール
//        let scrollView = UIScrollView()
//        scrollView.frame = self.view.frame
//        scrollView.contentSize = CGSize(width:self.view.frame.width, height:1000)
//        self.view.addSubview(scrollView)
        
        
        //起動画面　スプラッシュ
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "first")!,iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: UIColor(red:255.0, green:255.0, blue:255.0, alpha:1.0))
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }

        //UITextFieldのデリゲート
        mailForm.delegate = self
        passForm.delegate = self
        
        //見た目
        mailForm.layer.cornerRadius = 10
        passForm.layer.cornerRadius = 10
        nameForm.layer.cornerRadius = 10
        buttonImage.layer.cornerRadius = 10
        siginUpButton.layer.cornerRadius = 10
        logInButton.layer.cornerRadius = 10
        
    }
    
    //プロフィール画像選択
    @IBAction func selectImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present (imagePicker, animated: true, completion: nil)
        }
    }
    
    //選択した画像を画面に表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            buttonImage.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func siginUp(_ sender: UIButton) {
        //3つのフォームが入力されてる場合
        if nameForm.text != "" && mailForm.text != "" && passForm.text != "" {
            //入力したパスワードが7文字以上の場合
            if (passForm.text?.count)! > 6  {
                //会員登録開始
                Auth.auth().createUser(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                    //ログイン成功
                    if error == nil {
                        
                        guard let user = user else {
                            return
                        }
                        
                        //アドレスとか名前を別々で保存してたけど、一緒になる
                        let changeRequest = user.user.createProfileChangeRequest()
                        changeRequest.displayName = self.nameForm.text!
                        changeRequest.commitChanges(completion: { (error) in
                            
                        })
                        
                        //プロフィール画像をfirestoreに保存したい
                        let profileImage = self.buttonImage.imageView?.image!.jpegData(compressionQuality: 0.1)! as! Data
                        
                        
                        
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let riversRef = storageRef.child("profiles/\(user.user.uid).jpg")
                        let uploadTask = riversRef.putData(profileImage, metadata: nil) { (metadata, error) in
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                            }
                            let size = metadata.size
                            // You can also access to download URL after upload.
                            riversRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    return
                                }
                                
                                let changeRequest2 = user.user.createProfileChangeRequest()
                                changeRequest2.photoURL = downloadURL
                                changeRequest2.commitChanges(completion: { (error)in
                                    
                                })
                                
                                
                                //firestoreに接続
                                let userName = self.nameForm.text!
                                let db = Firestore.firestore()
                                db.collection("users").document(user.user.uid).setData([
                                    "name": userName,
                                    "uid": user.user.uid as Any,
                                    "photo":downloadURL.absoluteString
                                ])
                                
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
                        }
                        
                        
                        //ログイン失敗
                    } else {
                        print(error?.localizedDescription)
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
