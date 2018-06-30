//
//  MemeGridViewController.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/15/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import Foundation
import UIKit

class MemeGridViewController : UICollectionViewController {
 
    
    @IBOutlet weak var flowLayoutView: UICollectionViewFlowLayout!
    
    var memes :[Meme]!{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let space : CGFloat = 3.0
        var dimension : CGFloat
        if  UIDevice.current.orientation.isPortrait {
         dimension = (view.frame.width - ( 2 * space)) / 3.0
        }else{
         dimension = (view.frame.height - ( 2 * space)) / 3.0
        }
        print("cell width \(dimension)")
        flowLayoutView.minimumInteritemSpacing = space
        flowLayoutView.minimumLineSpacing = space
        flowLayoutView.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeController") as! ShowMemeViewController
        memeController.meme = memes[indexPath.item]
        navigationController?.pushViewController(memeController, animated: true)
    }
    
 
    
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeGridCell", for: indexPath) as! MemeCollectionViewCell
  
        cell.imageView.image = memes[indexPath.item].memeTextImage
    
        return cell
    }
    
    
}



