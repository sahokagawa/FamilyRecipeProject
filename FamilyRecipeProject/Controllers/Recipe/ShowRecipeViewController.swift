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
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        db.collection("groups").document("syj3D8VOvkazBwsB3duE").collection("recipes").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            
            //レシピがあった時の処理
            
            //            var recip:Recipe = Recipe(uid: <#String#>, name: name.text!, photoData: image , message: message) {
            //                didSet{
            //
            //
            //            }
            //        }
            
            
            for document in documents {
                let recipeId = document.get("recipeId") as! String
                db.collection("recipes").document(recipeId).getDocument(completion: { (documentSnapshot, error) in
                    if let document = documentSnapshot,documentSnapshot!.exists{
                        let recipeName = document.get("name") as! String
                        let recipeMessage = document.get("message")

                    }
                })
            }

        }

    }
    
    
    
}
