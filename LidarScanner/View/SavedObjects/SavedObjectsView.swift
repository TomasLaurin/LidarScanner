//
//  SavedObjectsView.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI
import SceneKit

struct SavedObjectsView : View {
    @StateObject private var viewModel = SavedObjectsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.fileNames.isEmpty {
                    Text("No files")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .background(.black)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    List(viewModel.fileNames, id: \.self) { fileName in
                        Button(action: {
                            viewModel.currentlyDisplaying = fileName
                            viewModel.showModel.toggle()
                            
                        }) {
                            HStack {
                                Text(fileName)
                                Spacer()
                                ShareLink("", item: viewModel.getObjFileFullPath(fileName: fileName))
                                    .frame(maxWidth: 0)
                            }
                            .padding(4)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive, action: {
                                viewModel.removeFile(fileName: fileName)
                                withAnimation {
                                    viewModel.fetchFiles()
                                }
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.showModel) {
                        NavigationStack {
                            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                                if !viewModel.currentlyDisplaying.isEmpty {
                                    ModelView(viewModel:
                                        ModelViewModel(
                                            scene: viewModel.displayFile(fileName: viewModel.currentlyDisplaying)
                                        )
                                    )
                                }
                                Button(action: {
                                    viewModel.showModel = false
                                }) {
                                    Text("Back").padding()
                                }
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink {
                                            ModelViewAR(
                                                viewModel: ModelViewARModel(
                                                    scene: viewModel.displayFile(fileName: viewModel.currentlyDisplaying)
                                                )
                                            )
                                        } label: {
                                            Text("View in AR")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.blue)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.blue, lineWidth: 2)
                                                        )
                                                )
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchFiles()
                    }
                }
            }.onAppear {
                viewModel.fetchFiles()
            }
            .background(.black)

        }
    }
}


struct SavedObjectsViewPreview: PreviewProvider {
    static var previews: some View {
        SavedObjectsView()
    }
}

