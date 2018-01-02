//
//  AppDelegate.swift
//  OAuth2JSONDataTask
//
//  Created by Peter Spencer on 29/12/2017.
//  Copyright © 2017 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Property(s)
    
    var window: UIWindow?
    
    
    // MARK: - UIApplicationDelegate Protocol
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BasicController(nibName: nil, bundle: nil)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

