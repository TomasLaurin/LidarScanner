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
        arView.autoenablesDefaultLighting = false
        arView.session.run(configuration)
        
        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white
        
        for node in scene.rootNode.childNodes {
            if let geometry = node.geometry {
                geometry.materials = [whiteMaterial]
            }
        }
        
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
