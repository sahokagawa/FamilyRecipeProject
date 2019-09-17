//
//  ShowTryRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class ShowTryRecipeViewController: UIViewController {
    
    @IBOutlet weak var tryRecipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!
    
    
    
    var tryRecipe: TryRecipe? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.didClickButton))
        
        self.navigationItem.title = "作ってみた"
        
       tryRecipeImage.image = UIImage(data: tryRecipe!.photoData)
        name.text = tryRecipe?.name
        message.text = tryRecipe?.message
        message.isEditable = false
        
        message.layer.cornerRadius = 10

    }
    
    //通報のアラート
    @objc func didClickButton(_ sender: UIButton){
        let alert = UIAlertController(title: "通報する", message: "選択してください", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "通報する", style: .default) { (UIAlertAction) in
            //通報の処理
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (UIAlertAction) in
        }
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated:true , completion: nil)
    }
    
    

}
