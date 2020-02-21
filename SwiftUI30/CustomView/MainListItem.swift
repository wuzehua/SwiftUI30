//
//  MainListItem.swift
//  SwiftUI30
//
//  Created by RainZhong on 2020/2/21.
//  Copyright © 2020 RainZhong. All rights reserved.
//

import SwiftUI

struct MainListItem: View {
    
    var title:String
    var description:String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .bold()
                .font(.system(size: 22))
                
            
            Text(description)
                .font(.body)
            
        }.padding(.vertical, 3)
        
    }
}

struct MainListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MainListItem(title: "Test", description: "test")
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
