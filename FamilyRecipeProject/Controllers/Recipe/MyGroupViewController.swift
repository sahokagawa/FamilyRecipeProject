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
        
        
        //コレクションのレイアウト 余白
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
//        layout.itemSize = CGSize(width:180, height:180)
//        recipeCollection.collectionViewLayout = layout
        
        //ナビゲーション
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.didClickReSettingButton))
        
        recipeCollection.delegate = self
        recipeCollection.dataSource = self

        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
        //ナビゲーション
        self.parent!.navigationItem.title = group!.name
        print(group!.name)
        
        //レシピを表示させたい
        let db = Firestore.firestore()
        db.collection("groups").document(group!.uid).collection("recipes").getDocuments { (querySnapshot, error) in
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
                let recipeIngredients = document.get("ingredients") as! String
                let recipeHowTo = document.get("howTo") as! String
                
                let recipe = Recipe(uid: recipeId, name: recipeName, photoData: recipeImage,message: recipeMessage, ingredients: recipeIngredients, howTo: recipeHowTo)
                recipes.append(recipe)
            }
            
        }
    
    }
    
    
    //グループ設定ボタンが押されたら
    @objc func didClickReSettingButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "グループの設定", message: "選択してください", preferredStyle: .actionSheet)
        let editorAction = UIAlertAction(title: "編集", style: .default) { (UIAlertAction) in
            self.performSegue(withIdentifier: "toReSettingGroup", sender: self.group)
        }
//        let  deleteAction = UIAlertAction(title: "グループを退会する", style: .default) { (UIAlertAction) in
//            print("削除")
//        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(editorAction)
//        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated:true , completion: nil)
        
        
    }


}

extension MyGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0.5
        
       let imageView = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
           imageView.image = UIImage(named: "plus")
        }else{
            let recipe  = recipes[indexPath.row - 1]
            imageView.image = UIImage(data: recipe.photoData)
        }
        
        let label = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row == 0 {
            label.text = "レシピを書く"
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
            let recipe  = recipes[indexPath.row - 1]
            performSegue(withIdentifier: "toShowRecipe", sender: recipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowRecipe"{
            let nextVC = segue.destination as! ShowRecipeViewController
            nextVC.recipe = sender as! Recipe
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



