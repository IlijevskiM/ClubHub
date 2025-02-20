//
//  NotiTopBar.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct NotiBar: View {
    @Binding var currentButton : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
    HStack {
        
        Button(action: {
            currentButton = title
        }) {
            
            HStack {
                
                //VStack(spacing: 3) {
                    
                    HStack {
                        
                        Text(title)
                            .font(.system(size: 14))
                            //.fontWeight(currentButton == title ? .medium : .regular)
                            .foregroundColor(currentButton == title ? Color.black : Color.gray)
                            .padding(.horizontal,5)
                        
                            /*.padding(5)
                            .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(currentButton == titl ? Color.black : Color("back"))
                            )*/
                    }
                    
                    /*Rectangle()
                        .fill(.clear)
                        .frame(width: 60, height: 2)*/

                    // matched geometry effect slide animation
                    
                    /*if currentButton == titl {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 60, height: 2)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                        
                    }*/
                //}
            }
        }.padding(.top,5)
        
        }
    }
}

