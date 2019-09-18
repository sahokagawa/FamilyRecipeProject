//
//  MailViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/18.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import  MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startMailer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func startMailer() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["marumaruin12@gmail.com"]) // 宛先アドレス
            mail.setSubject("お問い合わせ") // 件名
            mail.setMessageBody("ここに本文が入ります。", isHTML: false) // 本文
            present(mail, animated: true, completion: nil)
        } else {
            print("送信できません")
        }
        
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
//            let alert  = UIAlertController(title: "送信完了", message: "メールを送信しました", preferredStyle: .alert)
//            let yesAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
//            }
//            alert.addAction(yesAction)
//            present(alert, animated: true, completion: nil)
            print("送信成功")
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
