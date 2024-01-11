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
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.white
        
        viewModel.scene?.rootNode.addChildNode(lightNode)
        
        scnView.scene = viewModel.scene
        scnView.backgroundColor = .clear
        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

