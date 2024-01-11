//
//  ModelView.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import SceneKit


struct ModelView : UIViewRepresentable {
    let viewModel: ModelViewModel
    
    func makeUIView(context: Context) -> some UIView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.antialiasingMode = .multisampling4X
        
        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white
        
        for node in viewModel.scene.rootNode.childNodes {
            if let geometry = node.geometry {
                geometry.materials = [whiteMaterial]
            }
        }
        
        scnView.scene = viewModel.scene
        scnView.backgroundColor = .clear

        return scnView
    }

    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

