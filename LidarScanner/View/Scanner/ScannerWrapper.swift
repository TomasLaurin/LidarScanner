//
//  LidarViewRepresentable.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 30.12.2023.
//

import SwiftUI
import ARKit
import RealityKit


// MARK: - Lidar Wrapper
// Lidar Wrapper for the use in our application

struct ScannerWrapper: UIViewRepresentable {
    @State var arView: ARView
    @Binding var isRecording: Bool
    @Binding var pausedRecording: Bool
    @Binding var fileName: String
    
    
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let configuration = configure()
        arView.debugOptions.insert(.showSceneUnderstanding)
        arView.session.run(configuration)
    }
    
    private func configure() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        
        if (isRecording && !pausedRecording) {
            configuration.environmentTexturing = .automatic
            
            arView.automaticallyConfigureSession = false
            configuration.sceneReconstruction = .meshWithClassification
            
            if type(of: configuration).supportsFrameSemantics(.sceneDepth) {
                configuration.frameSemantics = .sceneDepth
            }
        }
        
        return configuration
    }
}

