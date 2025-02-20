//
//  TopBar.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct TransitionBar: View {
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                withAnimation{current = title}
            }) {
                
                HStack {
                    
                    VStack(spacing: 6) {
                    
                    Text(title)
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(current == title ? Color.black : Color("darkGray"))
                        .padding(.horizontal)
                        
                        

                        // matched geometry effect slide animation
                        
                        if current == title {
                            Capsule()
                                .fill(.blue)
                                .frame(width: title == "Drafts" ? 44 : 55, height: 2.5)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                            
                        } else {
                            Capsule()
                                .fill(.clear)
                                .frame(width: title == "Drafts" ? 44 : 55, height: 2.5)
                        }
                    }
                }
            }
            
            }
    }
}

