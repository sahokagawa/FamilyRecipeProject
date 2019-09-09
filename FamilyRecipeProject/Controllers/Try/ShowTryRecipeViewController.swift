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
    @IBOutlet weak var message: UILabel!
    
    
    var tryRecipe: TryRecipe? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "作ってみました"
        
       tryRecipeImage.image = UIImage(data: tryRecipe!.photoData)
        name.text = tryRecipe?.name
        message.text = tryRecipe?.message

    }
    

}
