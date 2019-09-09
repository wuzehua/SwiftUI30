//
//  DarkModeTest.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/9.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import SwiftUI

extension UIViewController{
    var isDarkModeEnabled: Bool{
        traitCollection.userInterfaceStyle == .dark
    }
}

struct DarkModeTest: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack(alignment: .leading){
            Color(UIColor(named: "accentColor")!)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                Text("Now it's")
                    .font(.title)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .opacity(0.8)
                
                
                Text(colorScheme == .light ? "Light" : "Dark")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(colorScheme == .light ? .black : .white)

                
            }.padding()
        }
    }
}

struct DarkModeTest_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeTest()
            .environment(\.colorScheme, .light)
            .previewDevice("iPhone XR")
    }
}
