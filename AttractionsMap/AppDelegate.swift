//
//  AppDelegate.swift
//  AttractionsMap
//
//  Created by Никита Гундорин on 30.03.2020.
//  Copyright © 2020 Никита Гундорин. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let apiKey = "AIzaSyAztK1-L3NVzAsVOHmbhStCkSBNfjm88Wk"
        GMSServices.provideAPIKey(apiKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
