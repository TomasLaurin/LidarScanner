//
//  SavedObjectsViewModel.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import SceneKit

class SavedObjectsViewModel : ObservableObject {
    @Published var currentlyDisplaying = ""
    @Published var fileNames: [String] = []
    @Published var showModel = false
    @Published var navigateToARView = false
    @Published var showModelInAR = false
    
    @Published var showAlertRetrieving = false
    @Published var showAlertRemoving = false
    
    private let folderName = "created_models"
    
    func fetchFiles() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return	
        }
        
        let folderPath = documentsDirectory.appendingPathComponent(folderName)
        do {
            let filePath = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
            // do not show files with texture
            let filteredFiles = filePath.filter { (path) -> Bool in
                return path.pathExtension == "obj"
            }
            fileNames = filteredFiles.map { $0.lastPathComponent }
        } catch {
            showAlertRetrieving = true
        }
    }
    
    
    func displayFile(fileName: String) -> SCNScene {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access directory.")
        }
        
        let folderPath = directory.appendingPathComponent(folderName)
        let filePath = folderPath.appendingPathComponent(fileName)
        let sceneView = try? SCNScene(url: filePath)
        return sceneView ?? SCNScene()
    }
    
    func removeFile(fileName: String) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access directory.")
        }
        
        let fileNameWithoutExtension = fileName.split(separator: ".")[0]
        let folderPath = directory.appendingPathComponent(folderName)
        let objFilePath = folderPath.appendingPathComponent(fileName)
        let mtlFilePath = folderPath.appendingPathComponent(fileNameWithoutExtension + ".mtl")
        do {
            try FileManager.default.removeItem(at: objFilePath)
            try FileManager.default.removeItem(at: mtlFilePath)
        } catch {
            showAlertRemoving = true
        }
        
    }
    
    func getObjFileFullPath(fileName: String) -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to retrieve directory with saved objects.")
        }
        let folderPath = directory.appendingPathComponent(folderName)
        return folderPath.appendingPathComponent(fileName)
    }
    
    func getMtlFileFullPath(fileName: String) -> URL {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to retrieve directory with saved objects.")
        }
        let fileNameWithoutExtension = fileName.split(separator: ".")[0]
        let folderPath = directory.appendingPathComponent(folderName)
        return folderPath.appendingPathComponent(fileNameWithoutExtension + ".mtl")
    }
    
}
