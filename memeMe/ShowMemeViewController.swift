//
//  ShowMemeViewController.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/16/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import Foundation
import UIKit


class ShowMemeViewController: UIViewController{
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme:Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme?.memeTextImage
       
    }
    
}
