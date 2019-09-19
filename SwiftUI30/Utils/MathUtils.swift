//
//  Matrix.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/18.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import Foundation
import MetalKit

struct Vertex {
    var position: vector_float4
    var color: vector_float4
}


struct Uniforms {
    var MVP: matrix_float4x4
}

func makeTranslationMatrix(displacement: vector_float3) -> matrix_float4x4 {
    var result = matrix_float4x4()
    for i in 0..<4{
        result[i][i] = 1.0
        if i != 3{
            result[i][3] = displacement[i]
        }
    }
    return result
}

func makeScaleMatrix(scale: vector_float3) -> matrix_float4x4 {
    var result = matrix_float4x4()
    for i in 0..<4{
        if i == 3{
            result[i][i] = 1.0
        }
        else{
            result[i][i] = scale[i]
        }
    }
    return result
}

func makeRotationXMatrix(theta: Float) -> matrix_float4x4{
    var result = matrix_float4x4(1.0)
    result[1][1] = cos(theta)
    result[1][2] = -sin(theta)
    result[2][1] = sin(theta)
    result[2][2] = cos(theta)
    return result
}

func makeRotationYMatrix(theta: Float) -> matrix_float4x4{
    var result = matrix_float4x4(1.0)
    result[0][0] = cos(theta)
    result[0][2] = sin(theta)
    result[2][0] = -sin(theta)
    result[2][2] = cos(theta)
    return result
}

func makeRotationZMatrix(theta: Float) -> matrix_float4x4{
    var result = matrix_float4x4(1.0)
    result[0][0] = cos(theta)
    result[0][1] = -sin(theta)
    result[1][0] = sin(theta)
    result[1][1] = cos(theta)
    return result
}

func makeProjectionMatrix(near: Float, far: Float, aspect: Float, angleOfView: Float) -> matrix_float4x4{
    let scaleY = 1 / tan(angleOfView / 2)
    let scaleX = scaleY / aspect
    let scaleZ = -(far + near) / (far - near)
    let scaleW = -2 * far * near / (far - near)
    let X = vector_float4(scaleX,0,0,0)
    let Y = vector_float4(0,scaleY,0,0)
    let Z = vector_float4(0,0,scaleZ,-1)
    let W = vector_float4(0,0,scaleW,0)
    return matrix_float4x4(columns: (X,Y,Z,W))
}



//Metal Matrix 是按列排，不是行
struct Matrix {
    private var data: [Float]
    
    var m:[Float]{ data }
    
    init() {
        data = [1,0,0,0,
                0,1,0,0,
                0,0,1,0,
                0,0,0,1]
    }
    
    static func *(_ mata: Matrix, _ matb: Matrix) -> Matrix {
        var result = Matrix()
        var temp: Float = 0.0
        for i in 0...3{
            for j in 0...3{
                temp = 0.0
                for k in 0...3{
                    temp += mata.data[4 * i + k] * matb.data[4 * k + j]
                }
                result.data[4 * i + j] = temp
            }
        }
        return result
    }
    
    static func makeTranslationMatrix(displacement: vector_float3) -> Matrix{
        var result = Matrix()
        result.data[12] = displacement.x
        result.data[13] = displacement.y
        result.data[14] = displacement.z
        return result
    }
    
    static func makeScaleMatrix(scale: vector_float3) -> Matrix{
        var result = Matrix()
        result.data[0] = scale.x
        result.data[5] = scale.y
        result.data[10] = scale.z
        return result
    }
    
    static func makeRotationXMatrix(theta: Float) -> Matrix{
        var result = Matrix()
        result.data[5] = cos(theta)
        result.data[9] = -sin(theta)
        result.data[6] = sin(theta)
        result.data[10] = cos(theta)
        return result
    }
    
    static func makeRotationYMatrix(theta: Float) -> Matrix{
        var result = Matrix()
        result.data[0] = cos(theta)
        result.data[8] = sin(theta)
        result.data[2] = -sin(theta)
        result.data[10] = cos(theta)
        return result
    }
    
    static func makeRotationZMatrix(theta: Float) -> Matrix{
        var result = Matrix()
        result.data[0] = cos(theta)
        result.data[4] = -sin(theta)
        result.data[1] = sin(theta)
        result.data[5] = cos(theta)
        return result
    }
    
    static func makeProjectionMatrix(near: Float, far: Float, aspect: Float, angleOfView: Float) -> Matrix{
        var result = Matrix()
        let scaleY = 1 / tan(angleOfView / 2)
        let scaleX = scaleY / aspect
        let scaleZ = -(far + near) / (far - near)
        let scaleW = -2 * far * near / (far - near)
        result.data[0] = scaleX
        result.data[5] = scaleY
        result.data[10] = scaleZ
        result.data[14] = -1
        result.data[11] = scaleW
        result.data[15] = 0
        return result
    }
    
}
