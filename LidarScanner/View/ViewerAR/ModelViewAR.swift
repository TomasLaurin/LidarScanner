//
//  ModelViewAR.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 09.01.2024.
//

import SwiftUI
import SceneKit
import ARKit

struct ModelViewAR: View {
    let viewModel: ModelViewARModel

    
    var body: some View {
        ARViewContainer(
            arView: viewModel.arView,
            scene: viewModel.scene
        )
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            viewModel.cleanupARView()
        }
    }
}

