//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Matthew Jannace on 10/15/20.
//

import SwiftUI

@main
struct FeatureFlagingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SegmentTestContentView()
        }
    }
}
