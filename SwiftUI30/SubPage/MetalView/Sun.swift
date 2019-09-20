//
//  Sun.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/20.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import SwiftUI

struct Sun: View {
    var body: some View {
        GeometryReader { proxy in
            MathCanvas(frame: CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height), delegate: MathView(funcName: "compute"))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct Sun_Previews: PreviewProvider {
    static var previews: some View {
        Sun()
        .previewDevice("iPhone XR")
    }
}
