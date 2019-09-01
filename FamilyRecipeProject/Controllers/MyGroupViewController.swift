//
//  MyGroupViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class MyGroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    //グループ設定ボタンが押されたら
    @IBAction func didClickReSettingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toReSettingGroup", sender: nil)
    }
    
    

}
