//
//  MyGroupViewController.swift
//  FamilyRecipeProject
//
//  Created by 香川紗穂 on 2019/08/29.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class MyGroupViewController: UIViewController {
    
    
    //前の画面から選択されたグループの情報を受け取るための箱
    var group: Group? = nil
    
    @IBOutlet weak var recipeCollection: UICollectionView!
    var recipes : [Recipe] = []{
        didSet{
            recipeCollection.reloadData()
            
        }
    }
            

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollection.delegate = self
        recipeCollection.dataSource = self

        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
        
        
        //レシピを表示させたい
        let db = Firestore.firestore()
        db.collection("groups").document("syj3D8VOvkazBwsB3duE").collection("recipes").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            //レシピがあった時の処理
            var recipes:[Recipe] = [] {
                didSet{
                    self.recipes = recipes
                }
            }
            
            for document in documents {
                let recipeId = document.documentID
                let recipeName = document.get("name") as! String
                let recipeMessage = document.get("message") as! String
                let recipeImage = document.get("photoData") as! Data
                
                let recipe = Recipe(uid: recipeId, name: recipeName, photoData: recipeImage,message: recipeMessage)
                recipes.append(recipe)
            }
            
        }
    
    }
    //グループ設定ボタンが押されたら
    @IBAction func didClickReSettingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toReSettingGroup", sender: nil)
    }


}

extension MyGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
       let imageView = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
           imageView.image = UIImage(named: "4")
        }else{
            let recipe  = recipes[indexPath.row - 1]
            imageView.image = UIImage(data: recipe.photoData)
        }
        
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            label.text = "追加"
        }else{
            let recipe  = recipes[indexPath.row - 1]
            label.text = recipe.name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toWriteRecipe", sender: nil)
        } else {
            performSegue(withIdentifier: "toShowRecipe", sender: nil)
        }
    }

}


    

//tabとかnaviコントローラー挟んで、処理が面倒だったからappdelegateを使ってデータを渡してる！
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toWriteRecipe" {
//             let nextVC = segue.destination as! WriteRecipeViewController
//             nextVC.group = sender as! Group
//        }
//
//    }



