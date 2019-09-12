//
//  ShowRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import ReadMoreTextView
//import ExpandableLabel

class ShowRecipeViewController: UIViewController {
    
    let scrollView = UIScrollView()
    

    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var message: UILabel!
//    @IBOutlet weak var ingredients: ExpandableLabel!
    @IBOutlet weak var ingredient: ReadMoreTextView!
    
//    @IBOutlet weak var ingredients: NSLayoutConstraint!
//    var isLabelAtMaxHeight = false
//    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var howTo: ReadMoreTextView!
    @IBOutlet weak var message: ReadMoreTextView!
    
  
    
    
    var recipe: Recipe? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "レシピ"
        
        ingredient.isEditable = false
        ingredient.text = recipe?.ingredients
        ingredient.shouldTrim = true
        ingredient.maximumNumberOfLines = 2
        ingredient.attributedReadMoreText = NSAttributedString(string: "...続きを読む")
        ingredient.attributedReadLessText = NSAttributedString(string: "...閉じる")
        
        
//        ingredients.text = recipe?.ingredients
//        ingredients.collapsed = true
//        ingredients.numberOfLines = 1
//        ingredients.collapsedAttributedLink = NSAttributedString(string: "...続きを読む")
//        ingredients.expandedAttributedLink = NSAttributedString(string: "閉じる")
//        ingredients.setLessLinkWith(lessLink: "Close", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red], position: nil)
//        ingredients.ellipsis = NSAttributedString(string: "...")
        
        howTo.isEditable = false
        howTo.text = recipe?.howTo
        howTo.shouldTrim = true
        howTo.maximumNumberOfLines = 2
        howTo.attributedReadMoreText = NSAttributedString(string: "...続きを読む")
        ingredient.attributedReadLessText = NSAttributedString(string: "...閉じる")
        
        message.isEditable = false
        message.text = recipe?.message
        message.shouldTrim = true
        message.maximumNumberOfLines = 2
        message.attributedReadMoreText = NSAttributedString(string: "...続きを読む")
        message.attributedReadLessText = NSAttributedString(string: "...閉じる")

        
        
        
        
        recipeImage.image = UIImage(data: recipe!.photoData)
        name.text = recipe?.name
        
        



        }
    
    }


