//
//  EventTags.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Eventtags: View {
    
    @Binding var selected : String
    var type : String
    var animation : Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation{selected = type}
        }) {
            
            ZStack {
                
                Text(type)
                    .foregroundColor(selected == type ? Color.black : Color.black.opacity(0.6))
                    .fontWeight(selected == type ? .medium : .regular)
                    .font(.system(size: 12))
                
                if selected == type {
                    Capsule()
                        .strokeBorder(.black, lineWidth: 0.5)
                    //.fill(Color.gray.opacity(0.1))
                        .frame(width: 75, height: 30)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                    
                } else {
                    Capsule()
                        .fill(.clear)
                        .frame(width: 75, height: 30)
                }
                
            }
            
            
        }
    }
}
