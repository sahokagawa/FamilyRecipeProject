//
//  TryRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class TryRecipeViewController: UIViewController {
    
    @IBOutlet weak var tryRecipeCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryRecipeCollection.delegate = self
        tryRecipeCollection.dataSource = self

    }
    


}


extension TryRecipeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
            imageView.image = UIImage(named: "4")
        }else{
            imageView.image = UIImage(named: "1")
        }
        
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            label.text = "追加"
        }else{
            label.text = "料理名"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toWriteTryRecipe", sender: nil)
        }else{
            performSegue(withIdentifier: "toWriteShowRecipe", sender: nil)
        }
    }
    
}
