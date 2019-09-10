//
//  TryRecipeViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/09/03.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class TryRecipeViewController: UIViewController {
    
    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
    
    @IBOutlet weak var tryRecipeCollection: UICollectionView!
    var tryRecipes : [TryRecipe] = []{
        didSet {
            tryRecipeCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "グループの名前"
        
        tryRecipeCollection.delegate = self
        tryRecipeCollection.dataSource = self
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
        
        //作ってみたを表示させたい
        let db = Firestore.firestore()
        
        db.collection("groups").document(group!.uid).collection("tryRecipes").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            
            //作ってみたレシピがあった時
            var tryRecipes:[TryRecipe] = [] {
                didSet{
                    self.tryRecipes = tryRecipes
                }
            }
            
            for document in documents {
                let recipeId = document.documentID
                let recipeName = document.get("name") as! String
                let recipeMessage = document.get("message") as! String
                let recipeImage = document.get("photoData") as! Data
                
                let tryRecipe = TryRecipe(uid: recipeId, name: recipeName, photoData: recipeImage,message: recipeMessage)
                tryRecipes.append(tryRecipe)
            }
        }

    }

}


extension TryRecipeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tryRecipes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        let imageView = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
            imageView.image = UIImage(named: "plus")
        }else{
            let tryRecipe = tryRecipes[indexPath.row - 1]
            imageView.image = UIImage(data: tryRecipe.photoData)
        }
        
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            label.text = "追加"
        }else{
            let tryRecipe = tryRecipes[indexPath.row - 1]
            label.text = tryRecipe.name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toWriteTryRecipe", sender: nil)
        }else{
             let tryRecipe = tryRecipes[indexPath.row - 1]
            performSegue(withIdentifier: "toShowTryRecipe", sender: tryRecipe)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowTryRecipe" {
            let nextVC = segue.destination as! ShowTryRecipeViewController
            nextVC.tryRecipe = sender as! TryRecipe
        }
    }
}


