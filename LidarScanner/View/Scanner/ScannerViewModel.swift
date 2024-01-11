//
//  ScannerViewModel.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import RealityKit
import ARKit


final class ScannerViewModel : ObservableObject {
    @Published var isRecording = false
    @Published var pausedRecording = false
    @Published var finishedRecording = false
    @Published var fullScreenMode = true
    @Published var fileName = ""
    @Published var saveFile = false
    @Published var showObjects = false
    
    @State var arView = ARView(frame: .zero)
    
    func resetSettings() {
        isRecording = false
        pausedRecording = false
        finishedRecording = false
        fullScreenMode = true
        fileName = ""
        saveFile = false
        
        arView.session.run(ARWorldTrackingConfiguration(), options: [.removeExistingAnchors, .resetTracking])
    }
    
    func startRecording() {
        isRecording = true
    }
    
    func pauseRecording() {
        pausedRecording.toggle()
    }
    
    func stopRecording() {
        isRecording = false
        finishedRecording = true
    }
    
    func toggleResize() {
        fullScreenMode.toggle()
    }
    
    func showObjectList() {
        showObjects.toggle()
    }
    
    func cleanupARView() {
        arView.session.pause()
        arView.removeFromSuperview()
    }
    
    func saveModel() {
        guard let camera = arView.session.currentFrame?.camera else { return }
        
        if let mesh = arView.session.currentFrame?.anchors.compactMap({ $0 as? ARMeshAnchor }),
            let asset = convertScanToModel(meshAnchors: mesh, camera: camera) {
            do {
                try export(asset: asset, fileName: fileName)
            } catch {
                print("Export error")
            }
        }
    }
    
    private func convertScanToModel(meshAnchors: [ARMeshAnchor], camera: ARCamera) -> MDLAsset? {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        
        let asset = MDLAsset()
        
        for anchor in meshAnchors {
            let mdlMesh = anchor.geometry.convertToMesh(device: device, modelMatrix: anchor.transform)
            asset.add(mdlMesh)
        }
        
        return asset
    }
    
    private func export(asset: MDLAsset, fileName: String) throws {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "cz.tomaslaurin.LidarScanner", code: 153)
        }
        
        let folderName = "created_models"
        let folderURL = directory.appendingPathComponent(folderName)
        
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        
        let url = folderURL.appendingPathComponent("\( fileName.isEmpty ? UUID().uuidString : fileName ).obj") // save defaultly as obj file
        
        do {
            try asset.export(to: url)
            print("Object saved successfully at: ", url)
        } catch {
            print("Error saving .obj file \(error)")
        }
    }
}
