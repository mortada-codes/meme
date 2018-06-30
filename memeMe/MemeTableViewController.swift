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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! UIImageCellTableView
        cell.memeImageView?.image = meme.memeTextImage
        cell.memeImageView?.contentMode = .scaleToFill
        cell.label?.text = meme.topText
        return cell
    }
    
  
}


class UIImageCellTableView : UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
  
}
