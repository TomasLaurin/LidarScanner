//
//  Mesh.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 30.12.2023.
//


import RealityKit
import ARKit
import MetalKit

extension ARMeshGeometry {
    
    // Retrieves a vertex at a given index.
    // - Parameter index: The index of the vertex to retrieve.
    // - Returns: A SIMD3<Float> representing the vertex.
    // https://developer.apple.com/documentation/arkit/armeshgeometry/3516924-vertices
    func vertex(at index: UInt32) -> SIMD3<Float> {
        assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return vertex
    }
    

    // Converts ARMeshGeometry to a Model I/O mesh (MDLMesh).
    // - Parameters:
    //   - device: The Metal device used for buffer allocation.
    //   - camera: The ARCamera for potential future use.
    //   - modelMatrix: The transformation matrix for the mesh.
    // - Returns: An MDLMesh created from the ARMeshGeometry.
    // https://developer.apple.com/documentation/arkit/arkit_in_ios/content_anchors/visualizing_and_interacting_with_a_reconstructed_scene
    // https://stackoverflow.com/questions/61063571/arkit-how-to-export-obj-from-iphone-ipad-with-lidar
    func convertToMesh(device: MTLDevice, modelMatrix: simd_float4x4) -> MDLMesh {
        let verticesPointer = vertices.buffer.contents()

        // Transform and store each vertex.
        for vertexIndex in 0..<vertices.count {
            let vertex = self.vertex(at: UInt32(vertexIndex))
            
            var vertexTransform = matrix_identity_float4x4
            vertexTransform.columns.3 = SIMD4<Float>(vertex.x, vertex.y, vertex.z, 1)
            let worldPosition = (modelMatrix * vertexTransform).columns.3

            let offset = vertices.offset + vertices.stride * vertexIndex
            let stride = vertices.stride / 3
            verticesPointer.storeBytes(of: worldPosition.x, toByteOffset: offset, as: Float.self)
            verticesPointer.storeBytes(of: worldPosition.y, toByteOffset: offset + stride, as: Float.self)
            verticesPointer.storeBytes(of: worldPosition.z, toByteOffset: offset + 2 * stride, as: Float.self)
        }
        
        // Create vertex and index buffers.
        let vertexData = Data(bytes: verticesPointer, count: vertices.stride * vertices.count)
        let allocator = MTKMeshBufferAllocator(device: device)
        let vertexBuffer = allocator.newBuffer(with: vertexData, type: .vertex)

        let indexData = Data(bytes: faces.buffer.contents(), count: faces.bytesPerIndex * faces.count * faces.indexCountPerPrimitive)
        let indexBuffer = allocator.newBuffer(with: indexData, type: .index)
        
        // Create submesh and mesh.
        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                 indexCount: faces.count * faces.indexCountPerPrimitive,
                                 indexType: .uInt32,
                                 geometryType: .triangles,
                                 material: nil)
        
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: vertices.stride)
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float3,
                                                            offset: 0,
                                                            bufferIndex: 0)

        return MDLMesh(vertexBuffer: vertexBuffer,
                       vertexCount: vertices.count,
                       descriptor: vertexDescriptor,
                       submeshes: [submesh])
    }
}

