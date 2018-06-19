//
//  MemeTableViewController.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/15/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import Foundation
import  UIKit

class MemeTableViewController : UITableViewController {
    
    var memes :[Meme]!{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return memes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let memeController = storyboard?.instantiateViewController(withIdentifier: "ShowMemeController") as! ShowMemeViewController
        memeController.meme = memes[indexPath.item]
        navigationController?.pushViewController(memeController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let meme = memes[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")
        cell?.imageView?.image = meme.memeImage
        cell?.textLabel?.text = meme.topText
        cell?.detailTextLabel?.text = meme.bottomText
        return cell!
    }
    
  
}
