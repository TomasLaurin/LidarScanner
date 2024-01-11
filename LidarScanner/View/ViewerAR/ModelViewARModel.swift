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
        makeModelsInSceneWhite()
    }
    
    func cleanupARView() {
        arView.session.pause()
        arView.removeFromSuperview()
    }

    private func makeModelsInSceneWhite() {
        scene.rootNode.enumerateChildNodes { (node, _) in
            self.makeNodeWhite(node)
        }
    }

    private func makeNodeWhite(_ node: SCNNode) {
        if let geometry = node.geometry {
            for material in geometry.materials {
                material.diffuse.contents = UIColor.white
            }
        }

        for childNode in node.childNodes {
            makeNodeWhite(childNode)
        }
    }
}
