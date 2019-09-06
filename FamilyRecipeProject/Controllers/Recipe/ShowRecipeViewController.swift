//
//  ShowRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class ShowRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    
    
    var recipe: Recipe? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        recipeImage.image = UIImage(data: recipe!.photoData)
        name.text = recipe?.name
        message.text = recipe?.message



        }

    }
    
    

