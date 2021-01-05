//
//  AppDelegate.swift
//  Landmarks
//
//  Created by Matthew Jannace on 11/11/20.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        bAnalytics.sharedInstance.enable()
        
        return true
    }
}
