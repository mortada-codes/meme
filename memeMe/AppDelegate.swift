//
//  AppDelegate.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/14/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes:[Meme] = []

    func addMeme(_ meme:Meme){
        memes.append(meme)
    }
}

