//
//  BecameAClubOwner.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/12/23.
//

import SwiftUI

struct BecameAClubOwner: View {
    @Binding var showClubOwnerStatus: Bool
    var body: some View {
        
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Successfully added")
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("You have received club owner privileges. \nNow go be a leader!")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding(.top,12)
            
        }.padding(.horizontal,20).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(.spring())
    }
}
