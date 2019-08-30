//
//  ChooseMemberViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class ChooseMemberViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
// グループメンバーを選んで次のページに行く時
    
    @IBAction func toSettingGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettingGroup", sender: nil)
    }
    
}
