//
//  AppDelegate.swift
//  KMImageLoader
//
//  Created by Kevin McGill on 3/19/15.
//  Copyright (c) 2015 McGill DevTech, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Clear images cached on disk at launch
        ImageLoader.sharedLoader.cleanDiskCache()
        
        return true
    }
}

