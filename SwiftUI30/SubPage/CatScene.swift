//
//  CatScene.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/10.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import SwiftUI

struct CatScene: View {
    var body: some View {
        SceneKitView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct CatScene_Previews: PreviewProvider {
    static var previews: some View {
        CatScene()
        .previewDevice("iPhone XR")
    }
}
