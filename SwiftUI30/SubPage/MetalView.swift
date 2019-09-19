//
//  MetalView.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/18.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import MetalKit
import simd

class MetalView: MTKView {
    private var commandQueue: MTLCommandQueue?
    private var rps: MTLRenderPipelineState?
    private var vertexBuffer: MTLBuffer?
    private var uniformBuffer: MTLBuffer?
    private var indexBuffer: MTLBuffer?
    
//    private var projectionMatrix: matrix_float4x4!
//    private var viewMatrix: matrix_float4x4!
//    private var modelMatrix: matrix_float4x4!
    
    private var projectionMatrix: Matrix!
    private var viewMatrix: Matrix!
    private var modelMatrix: Matrix!
    
    private var cameraPosition: vector_float3!
    
    private var theta: Float = 0.0
    
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
        initProjection()
        initViewMatrix()
        modelMatrix = Matrix.makeScaleMatrix(scale: vector3(0.5, 0.5, 0.5))
        createBuffer()
        registerShader()
    }
    
    required override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        initProjection()
        initViewMatrix()
        modelMatrix = Matrix.makeScaleMatrix(scale: vector3(0.5, 0.5, 0.5))
        createBuffer()
        registerShader()
//        print(projectionMatrix)
//        print(viewMatrix)
//        print(modelMatrix)
    }
    
    private func initProjection(){
        let aspect = Float(drawableSize.width / drawableSize.height)
        print("aspect = \(aspect)")
        //projectionMatrix = makeProjectionMatrix(near: 1, far: 5, aspect: aspect, angleOfView: 1.1)
        projectionMatrix = Matrix.makeProjectionMatrix(near: 0, far: 10, aspect: aspect, angleOfView: 1)
    }
    
    private func initViewMatrix(){
        cameraPosition = vector_float3(0,0,-3.0)
        //viewMatrix = makeTranslationMatrix(displacement: cameraPosition)
        viewMatrix = Matrix.makeTranslationMatrix(displacement: -cameraPosition)
    }
    
    override func draw(_ rect: CGRect) {
        if let drawable = currentDrawable,
            let rpd = currentRenderPassDescriptor{
            
            //color attachments为一组纹理，用于保存绘图结果并显示在屏幕上
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
            rpd.colorAttachments[0].loadAction = .clear
            
            //command queue为命令缓冲区的串行序列，确定储存的命令执行的顺序
            //command buffer用于储存命令
            
            
            
            let commandBuffer = device!.makeCommandQueue()?.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            
            commandEncoder?.setRenderPipelineState(rps!)
            commandEncoder?.setFrontFacing(.counterClockwise)
            commandEncoder?.setCullMode(.back)
            
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
            //commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indexBuffer!.length / MemoryLayout<UInt16>.size, indexType: MTLIndexType.uint16, indexBuffer: indexBuffer!, indexBufferOffset: 0)
            commandEncoder?.endEncoding()
            
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
            
            
            updateView()
        }
    }
    
    func createBuffer(){
        commandQueue = device?.makeCommandQueue()
        let vertexData = [Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [1,0,0,1]),
                          Vertex(position: [0.5, -0.5, 0.0, 1.0], color: [0,1,0,1]),
                          Vertex(position: [0.5, 0.5, 0.0, 1.0], color: [0,0,1,1]),
                          Vertex(position: [-0.5, 0.5, 0.0, 1.0], color: [0,0,0,1]),
                          Vertex(position: [-0.5, -0.5, -0.5, 1.0], color: [0,1,1,1]),
                          Vertex(position: [0.5, -0.5, -0.5, 1.0], color: [1,0,1,1]),
                          Vertex(position: [0.5, 0.5, -0.5, 1.0], color: [1,1,0,1]),
                          Vertex(position: [-0.5, 0.5, -0.5, 1.0], color: [1,1,1,1])
        ]
        
        let vertexIndex:[UInt16] = [0, 1, 2, 2, 3, 0, //front
                                    4, 0, 3, 3, 7, 4, //left
                                    3, 2, 6, 6, 7, 3, //top
                                    7, 6, 5, 5, 4, 7, //back
                                    1, 5, 6, 6, 2, 1, //right
                                    4, 5, 1, 1, 0, 4  //bottom
        ]
        
        vertexBuffer = device?.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Vertex>.size, options: [])
        uniformBuffer = device?.makeBuffer(length: MemoryLayout<Uniforms>.size, options: [])
        indexBuffer = device?.makeBuffer(bytes: vertexIndex, length: vertexIndex.count * MemoryLayout<UInt16>.size, options: [])
        
        print("indexCount = \(indexBuffer!.length / MemoryLayout<UInt16>.size)")
        
        let bufferPointer = uniformBuffer?.contents()
        let MVP = projectionMatrix * viewMatrix * modelMatrix
//        var uniforms = Uniforms(MVP: modelMatrix)
//        print("uniform size = \(MemoryLayout<Uniforms>.size) float size = \(16 * MemoryLayout<Float>.size)")
        memcpy(bufferPointer, MVP.m, 16 * MemoryLayout<Float>.size)
        
    }
    
    func registerShader(){
        let library = device?.makeDefaultLibrary()! //create a shader
        let vertexFunc = library?.makeFunction(name: "vertex_func") //create functions
        let fragmentFunc = library?.makeFunction(name: "fragment_func")
        let rpld = MTLRenderPipelineDescriptor() //渲染管线描述符
        
        rpld.vertexFunction = vertexFunc
        rpld.fragmentFunction = fragmentFunc
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm//blue green red alpha 8 bit
        
        do{
            try rps = device?.makeRenderPipelineState(descriptor: rpld)
        }
        catch let error
        {
            fatalError("\(error)")
        }
    }
    
    func updateView(){
        theta += Float.pi / 400
        if theta >= 2 * Float.pi{
            theta = 0
        }
//        let rotateX = makeRotationXMatrix(theta: Float.pi / 4)
//        let rotateY = makeRotationYMatrix(theta: theta)
//        modelMatrix = matrix_multiply(rotateX, rotateY)
        let rotateX = Matrix.makeRotationXMatrix(theta: Float.pi / 4)
        let rotateY = Matrix.makeRotationYMatrix(theta: theta)
        modelMatrix = rotateX * rotateY
        let bufferPointer = uniformBuffer?.contents()
//        let MVP = matrix_multiply(projectionMatrix, matrix_multiply(viewMatrix, modelMatrix))
        let MVP = projectionMatrix * viewMatrix * modelMatrix
        //var uniform = Uniforms(MVP: MVP)
        memcpy(bufferPointer, MVP.m, 16 * MemoryLayout<Float>.size)
    }
    
}
