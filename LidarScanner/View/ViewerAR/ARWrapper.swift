//
//  ARWrapper.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 09.01.2024.
//

import SwiftUI
import SceneKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let arView: ARSCNView
    let scene: SCNScene
    
    func makeUIView(context: Context) -> ARSCNView {
        let configuration = configure()
        arView.allowsCameraControl = true
        arView.autoenablesDefaultLighting = true
        arView.session.run(configuration)
        arView.scene = scene
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) { }
    
    func configure() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }
}
