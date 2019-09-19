//
//  ContentView.swift
//  SwiftUI30
//
//  Created by RainZhong on 2019/9/9.
//  Copyright © 2019 RainZhong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: PlusASecond()){
                    Text("Plus A Second")
                }
                
                NavigationLink(destination: DarkModeTest()){
                    Text("Dark Mode Test")
                }
                
                NavigationLink(destination: ColorMixer()){
                    Text("Color Mixer")
                }
                
                NavigationLink(destination: TypefaceComparison(rotationX: 0.0)){
                    Text("Typeface Comparison")
                }
                
                NavigationLink(destination: CatScene()){
                    Text("Cat Scene")
                }
                
                NavigationLink(destination: AnimationTextField()){
                    Text("Animation Text Field")
                }
                
                NavigationLink(destination: ZStackCard()){
                    Text("Z Stack Cards")
                }
                
                NavigationLink(destination: MetalTest()){
                    Text("Metal Test")
                }
                
            }.navigationBarTitle(Text("30Days"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().previewDevice("iPhone XR")
    }
}
