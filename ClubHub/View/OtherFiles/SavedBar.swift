//
//  SavedTopBar.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct SavedBar: View {
    @Binding var currentTab : String
    var tabTitle : String
    //var animation : Namespace.ID
    
    var body: some View {
        
    HStack {
        
        Button(action: {
            //withAnimation{currentTab = tabTitle}
            currentTab = tabTitle
        }) {
            
            Text(tabTitle)
                .font(.custom("Roboto-Medium", size: 14))
                .foregroundColor(currentTab == tabTitle ? Color("darkBlue") : .gray)
                .padding(.horizontal).padding(.vertical,5)
                .background(Capsule().strokeBorder(currentTab == tabTitle ? Color("darkBlue") : Color("back"), lineWidth: 1.5))
            }
        }
    }
}
