//
//  ModelViewARModel.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 09.01.2024.
//


import SceneKit
import ARKit

class ModelViewARModel {
    let arView = ARSCNView()
    var scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    func cleanupARView() {
        arView.session.pause()
        arView.removeFromSuperview()
    }
}
