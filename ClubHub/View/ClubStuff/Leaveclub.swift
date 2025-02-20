//
//  LeaveClub.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Leaveclub: View {
    @Binding var showLeavePopUp: Bool
    @Binding var confirmLeave: Bool
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Leave Club")
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Are you sure you want to leave \nthis club?")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                }
            }
                
                HStack(spacing: 10) {
                    Button {
                        showLeavePopUp.toggle()
                    } label: {
                        Text("Cancel")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.gray)
                            .padding(.vertical,8)
                            .padding(.horizontal,40)
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Color("back"))
                            )
                    }
                    Button {
                        showLeavePopUp.toggle()
                        confirmLeave.toggle()
                    } label: {
                        Text("Confirm")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical,8)
                            .padding(.horizontal,40)
                            .background(
                                RoundedRectangle(cornerRadius: 8).fill(Color("darkBlue"))
                            )
                    }
                }.padding(.top,10)
        }.padding(.horizontal,20).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(.spring())
    }
}
