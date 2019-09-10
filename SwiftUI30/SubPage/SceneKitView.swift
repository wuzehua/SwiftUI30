//
//  SceneKitView.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/10.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    
    let scene = SCNScene(named: "cat.scn")
    
    func makeUIView(context: Context) -> SCNView {
        //创建并向场景中添加摄像机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene?.rootNode.addChildNode(cameraNode)
        
        //在指定位置放置摄像机
        cameraNode.position = SCNVector3(x:0, y:0, z:15)
        
        //创造光照并添加到场景中，下面创建的是点光源
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.light!.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        lightNode.position = SCNVector3(x:0, y:0, z:50)
        scene?.rootNode.addChildNode(lightNode)
        
        
        //创造环境光，并添加到场景中
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        let scnView = SCNView()
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: UIViewRepresentableContext<SceneKitView>) {
        
        //设置场景
        uiView.scene = scene
        uiView.allowsCameraControl = true
        uiView.showsStatistics = true
        uiView.backgroundColor = .white
    }
}
