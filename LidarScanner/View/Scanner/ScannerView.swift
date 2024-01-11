//
//  ScannerView.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import ARKit
import RealityKit

// MARK: - Main View
struct ScannerView : View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        ZStack {
            // Lidar overlay
            cameraOverlay
                .frame(maxHeight: viewModel.fullScreenMode ? .infinity : 500)
                .ignoresSafeArea(.all)
            
            
            // Pause Button
            HStack {
                VStack {
                    objectListButton
                        .padding(20)
                    Spacer()
                    if (viewModel.isRecording) {
                        pauseButton
                            .padding()
                    }
                }
                Spacer()
            }
            
            // Record Button
            VStack() {
                Spacer()
                HStack {
                    recordButton
                }
            }
            .padding()
            
            // Resize Button
            VStack() {
                HStack {
                    Spacer()
                    resizeButton
                        .padding(.vertical, 75)
                        .padding(.horizontal, 20)
                        .ignoresSafeArea(.all)
                }
                Spacer()
            }
            
            if viewModel.showObjects {
                withAnimation {
                    NavigationViewDrawer(isOpen: $viewModel.showObjects) {
                        SavedObjectsView()
                    }
                    .padding(.vertical, 30)
                    .ignoresSafeArea()
                }
            }
            
            if viewModel.finishedRecording {
                nameInput
            }
        }
    }
    
    // MARK: - Camera View
    var cameraOverlay : some View {
        ScannerWrapper(
            arView: viewModel.arView,
            isRecording: $viewModel.isRecording,
            pausedRecording: $viewModel.pausedRecording,
            fileName: $viewModel.fileName
        )
        .onDisappear {
            viewModel.cleanupARView()
        }
    }
    
    // MARK: - Resize Button
    var resizeButton : some View {
        Button(action: {
            viewModel.toggleResize()
        }) {
            Image(systemName: viewModel.fullScreenMode ? "arrow.up.left.and.arrow.down.right.circle.fill" : "arrow.down.right.and.arrow.up.left.circle.fill")
            .resizable()
            .frame(width: 38, height: 38)
            .clipShape(Circle())
        }
    }
    
    // MARK: - Record Button
    var recordButton : some View {
        Button(action: {
            viewModel.isRecording ? viewModel.stopRecording() : viewModel.startRecording()
        }) {
            Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "record.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(viewModel.isRecording ? .red : .blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Pause Button
    var pauseButton : some View {
        Button(action: {
            viewModel.pauseRecording()
        }) {
            Image(systemName: viewModel.pausedRecording ? "arrowtriangle.right.fill" : "pause.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Object list
    var objectListButton : some View {
        Button(action: {
            viewModel.showObjectList()
        }) {
            Image(systemName: "line.3.horizontal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    // MARK: - Name Alert
    var nameInput : some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Select name")
                        .font(.headline)
                        .padding(.top)
                        .foregroundColor(Color.black)
                    
                    Text("Please name your scan")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    TextField("", text: $viewModel.fileName)
                        .textFieldStyle(.plain)
                        .placeholder(when: viewModel.fileName.isEmpty) {
                            Text("Your name").foregroundColor(.gray)
                        }
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            viewModel.resetSettings()
                        }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.red)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            if viewModel.fileName != "" {
                                viewModel.saveModel()
                                viewModel.resetSettings()
                            }
                        }) {
                            Text("Save")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.blue)
                        }
                        .padding()
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.all)
                Spacer()
            }
            .padding()
        }
        .padding()
    }
}


// MARK: - Preview

struct ScannerViewPreviews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
