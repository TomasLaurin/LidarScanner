//
//  LidarScannerApp.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import ARKit

// MARK: - Main app
@main
struct LidarScannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ScannerView()
        }
    }
}

// MARK: - App Delegate
// Checks for compatability
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Check if device suppoerts lidar scanning         // iphone 12 pro +         // ipad pro 2018 +
        if !ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            print("does not support AR")
        }
        return true
    }
}

