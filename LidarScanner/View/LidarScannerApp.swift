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
    @State private var showAlertExporting = false
    
    var body: some Scene {
        WindowGroup {
            ScannerView()
                .alert(isPresented: $showAlertExporting) {
                    Alert(
                        title: Text("Device Not Compatible"),
                        message: Text("This device does not support AR features required for the app."),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
    }
}

// MARK: - App Delegate
// Checks for compatibility
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if !ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            if let appDelegate = application.delegate as? AppDelegate {
                appDelegate.showAlertExporting = true
            }
        }
        return true
    }
    
    // Flag to control the alert
    var showAlertExporting = false
}


