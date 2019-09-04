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
    var recipes : [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollection.delegate = self
        recipeCollection.dataSource = self

        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        group = appDelegate.group
    }
    

    //グループ設定ボタンが押されたら
    @IBAction func didClickReSettingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toReSettingGroup", sender: nil)
    }
    
    

}


extension MyGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource{
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
            performSegue(withIdentifier: "toWriteRecipe", sender: nil)
        } else {
            performSegue(withIdentifier: "toShowRecipe", sender: nil)
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toWriteRecipe" {
//             let nextVC = segue.destination as! WriteRecipeViewController
//             nextVC.group = sender as! Group
//        }
//
//    }
    
}
