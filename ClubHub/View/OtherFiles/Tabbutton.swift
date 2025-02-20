//
//  TabButton.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Tabbutton: View {
    
    @Binding var selectedTab: String
    var image: String
    var title: String
    
    var body: some View {
        
        Button {
            
            withAnimation(.spring(response: 0.01, dampingFraction: 0.7, blendDuration: 0.7)){selectedTab = image}
            
        } label: {
                
                HStack(spacing: 10) {
                    
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(selectedTab == image ? .black : .gray)
                    
                    Text(title)
                        .font(Font.custom(selectedTab == image ? "Roboto-Medium" : "Roboto-Regular", size: 14))
                        .foregroundColor(selectedTab == image ? .black : .gray)
                    
                }
            
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading,15).padding(.vertical,10).background(RoundedRectangle(cornerRadius: 10).fill(selectedTab == image ? Color("back") : .clear))
    }
}

