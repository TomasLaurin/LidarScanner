//
//  ExportModel.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 30.12.2023.
//

import SwiftUI
import ARKit
import RealityKit

class ExportViewModel: NSObject, ObservableObject, ARSessionDelegate {
        
    func convertToAsset(meshAnchors: [ARMeshAnchor], camera: ARCamera) -> MDLAsset? {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }

        let asset = MDLAsset()

        for anchor in meshAnchors {
            let mdlMesh = anchor.geometry.toMDLMesh(device: device, camera: camera, modelMatrix: anchor.transform)
            asset.add(mdlMesh)
        }

        return asset
    }
    
    func export(asset: MDLAsset, fileName: String) throws -> URL {
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
            
            return url
        } catch {
            print("Error saving .obj file \(error)")
        }
        
        return url
    }
}
